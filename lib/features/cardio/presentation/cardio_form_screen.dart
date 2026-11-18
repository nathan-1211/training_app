import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums.dart';
import '../../../core/format.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/common.dart';
import '../../home/presentation/home_providers.dart';
import '../data/cardio_repository.dart';
import '../domain/pace.dart';

final cardioRepositoryProvider = Provider(
  (ref) => CardioRepository(ref.watch(databaseProvider)),
);

/// Registrar corrida (km + tempo → pace) ou EMOM/Cross (duração).
class CardioFormScreen extends ConsumerStatefulWidget {
  const CardioFormScreen({super.key, required this.type});
  final CardioType type;

  @override
  ConsumerState<CardioFormScreen> createState() => _CardioFormScreenState();
}

class _CardioFormScreenState extends ConsumerState<CardioFormScreen> {
  late CardioType _type = widget.type;
  final _km = TextEditingController();
  final _time = TextEditingController();
  final _notes = TextEditingController();
  int? _rpe;
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _km.addListener(() => setState(() {}));
    _time.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _km.dispose();
    _time.dispose();
    _notes.dispose();
    super.dispose();
  }

  bool get _isRun => _type == CardioType.run;
  int? get _seconds => parseDuration(_time.text);
  double? get _kmValue => parseDecimal(_km.text);

  int? get _pace {
    final km = _kmValue;
    final s = _seconds;
    if (!_isRun || km == null || s == null) return null;
    return paceSecPerKm(km: km, durationSec: s);
  }

  bool get _valid =>
      _seconds != null && _seconds! > 0 && (!_isRun || (_kmValue ?? 0) > 0);

  Future<void> _save() async {
    if (!_valid || _saving) return;
    setState(() => _saving = true);
    final now = DateTime.now();
    final date = DateTime(
      _date.year,
      _date.month,
      _date.day,
      now.hour,
      now.minute,
    );
    await ref
        .read(cardioRepositoryProvider)
        .save(
          type: _type,
          date: date,
          durationSec: _seconds!,
          km: _isRun ? _kmValue : null,
          rpe: _rpe,
          notes: _notes.text,
        );
    ref.read(dataVersionProvider.notifier).bump();
    if (!mounted) return;
    showSnack(context, '${_type.label} registrado');
    Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (d != null) setState(() => _date = d);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isRun ? 'Registrar corrida' : 'Registrar condicionamento'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SegmentedButton<CardioType>(
            segments: [
              for (final t in CardioType.values)
                ButtonSegment(value: t, label: Text(t.label)),
            ],
            selected: {_type},
            onSelectionChanged: (s) => setState(() => _type = s.first),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.event),
            label: Text('Data: ${formatDate(_date)}'),
          ),
          const SizedBox(height: 16),
          if (_isRun) ...[
            NumberField(
              key: const Key('cardio-km'),
              controller: _km,
              label: 'Distância',
              suffix: 'km',
              decimal: true,
              big: true,
            ),
            const SizedBox(height: 16),
          ],
          TextField(
            key: const Key('cardio-time'),
            controller: _time,
            keyboardType: TextInputType.datetime,
            style: theme.textTheme.headlineMedium,
            decoration: InputDecoration(
              labelText: _isRun
                  ? 'Tempo (mm:ss ou h:mm:ss)'
                  : 'Duração (min ou mm:ss)',
              hintText: _isRun ? '21:30' : '16',
            ),
          ),
          if (!_isRun && _seconds != null && !_time.text.contains(':'))
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Text(
                '= ${formatDuration(_seconds!)}',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          if (_isRun) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    const Icon(Icons.speed, size: 32),
                    const SizedBox(width: 12),
                    Text('Pace', style: theme.textTheme.titleLarge),
                    const Spacer(),
                    Text(
                      formatPace(_pace),
                      key: const Key('cardio-pace'),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SectionTitle('RPE (opcional)'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 1; i <= 10; i++)
                ChoiceChip(
                  label: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 6,
                    ),
                    child: Text('$i', style: const TextStyle(fontSize: 18)),
                  ),
                  selected: _rpe == i,
                  onSelected: (sel) => setState(() => _rpe = sel ? i : null),
                ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notes,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Notas (opcional)'),
          ),
          const SizedBox(height: 24),
          FilledButton(
            key: const Key('cardio-save'),
            onPressed: _valid && !_saving ? _save : null,
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
