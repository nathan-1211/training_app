import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/enums.dart';
import '../../../core/format.dart';
import '../../../core/widgets/common.dart';
import '../domain/set_entry.dart';

/// Hospeda a janela de registro: desce do topo (~300 ms) quando [data] fica
/// não-nulo e sobe/some quando volta a ser nulo. Deslizar para cima fecha.
class TopSheetHost extends StatefulWidget {
  const TopSheetHost({
    super.key,
    required this.data,
    required this.onConfirm,
    required this.onDismiss,
  });

  final SheetData? data;
  final ValueChanged<SetEntry> onConfirm;
  final VoidCallback onDismiss;

  @override
  State<TopSheetHost> createState() => _TopSheetHostState();
}

class _TopSheetHostState extends State<TopSheetHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );
  SheetData? _shown;
  double _drag = 0;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _shown = widget.data;
      _anim.forward();
    }
  }

  @override
  void didUpdateWidget(TopSheetHost old) {
    super.didUpdateWidget(old);
    if (widget.data != null) {
      _shown = widget.data;
      _drag = 0;
      _anim.forward();
    } else if (old.data != null) {
      FocusManager.instance.primaryFocus?.unfocus();
      _anim.reverse();
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        if (_anim.isDismissed || _shown == null) return const SizedBox.shrink();
        final t = Curves.easeOutCubic.transform(_anim.value);
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: widget.onDismiss,
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.55 * t),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: FractionalTranslation(
                translation: Offset(0, t - 1),
                child: Transform.translate(
                  offset: Offset(0, _drag),
                  child: GestureDetector(
                    onVerticalDragUpdate: (d) => setState(
                      () => _drag = (_drag + d.delta.dy).clamp(-400.0, 0.0),
                    ),
                    onVerticalDragEnd: (d) {
                      if (_drag < -60 || (d.primaryVelocity ?? 0) < -400) {
                        widget.onDismiss();
                      } else {
                        setState(() => _drag = 0);
                      }
                    },
                    child: _SheetBody(
                      key: ValueKey(_shown!.cursor),
                      data: _shown!,
                      onConfirm: widget.onConfirm,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SheetBody extends StatefulWidget {
  const _SheetBody({super.key, required this.data, required this.onConfirm});
  final SheetData data;
  final ValueChanged<SetEntry> onConfirm;

  @override
  State<_SheetBody> createState() => _SheetBodyState();
}

class _SheetBodyState extends State<_SheetBody> {
  late final _load = TextEditingController(text: _fmt(widget.data.prefillLoad));
  late final _reps = TextEditingController(
    text: widget.data.prefillReps?.toString() ?? '',
  );
  late final _distance = TextEditingController(
    text: _fmt(widget.data.prefillDistance),
  );
  late final _time = TextEditingController(
    text: widget.data.prefillDuration == null
        ? ''
        : formatDuration(widget.data.prefillDuration!),
  );
  bool _submitted = false;

  static String _fmt(double? v) =>
      v == null ? '' : formatNumber(v, maxDecimals: 2);

  @override
  void dispose() {
    _load.dispose();
    _reps.dispose();
    _distance.dispose();
    _time.dispose();
    super.dispose();
  }

  void _submit() {
    if (_submitted) return;
    final type = widget.data.logType;
    final entry = SetEntry(
      loadKg: type.hasLoad ? parseDecimal(_load.text) : null,
      reps: (type == LogType.loadReps || type == LogType.repsOnly)
          ? parseIntOrNull(_reps.text)
          : null,
      distanceM: type == LogType.loadDistance
          ? parseDecimal(_distance.text)
          : null,
      durationSec: type == LogType.timeOnly ? parseDuration(_time.text) : null,
    );
    _submitted = true;
    HapticFeedback.lightImpact();
    widget.onConfirm(entry);
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final theme = Theme.of(context);
    final type = d.logType;
    return Material(
      color: const Color(0xFF1C1D22),
      elevation: 12,
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                d.exercise.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Série ${d.setNumber} de ${d.totalSets}',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text('Meta: ${d.goalText}', style: theme.textTheme.titleMedium),
              if (d.lastTimeText != null)
                Text(
                  'Última vez: ${d.lastTimeText}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              if (d.exercise.tip.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    d.exercise.tip,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              if (type != LogType.confirmOnly)
                Row(
                  children: [
                    if (type.hasLoad)
                      Expanded(
                        child: NumberField(
                          key: const Key('field-load'),
                          controller: _load,
                          label: 'Carga (kg)',
                          decimal: true,
                          big: true,
                        ),
                      ),
                    if (type.hasLoad) const SizedBox(width: 12),
                    if (type == LogType.loadReps || type == LogType.repsOnly)
                      Expanded(
                        child: NumberField(
                          key: const Key('field-reps'),
                          controller: _reps,
                          label: 'Reps',
                          big: true,
                        ),
                      ),
                    if (type == LogType.loadDistance)
                      Expanded(
                        child: NumberField(
                          key: const Key('field-distance'),
                          controller: _distance,
                          label: 'Distância (m)',
                          decimal: true,
                          big: true,
                        ),
                      ),
                    if (type == LogType.timeOnly)
                      Expanded(
                        child: TextField(
                          key: const Key('field-time'),
                          controller: _time,
                          keyboardType: TextInputType.datetime,
                          style: theme.textTheme.headlineMedium,
                          decoration: const InputDecoration(
                            labelText: 'Tempo (mm:ss)',
                          ),
                        ),
                      ),
                  ],
                ),
              if (type != LogType.confirmOnly) const SizedBox(height: 16),
              SizedBox(
                height: 76,
                child: FilledButton(
                  key: const Key('sheet-ok'),
                  onPressed: _submit,
                  child: Text(
                    'OK',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
