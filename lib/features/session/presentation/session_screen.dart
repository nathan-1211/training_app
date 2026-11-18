import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/common.dart';
import '../domain/rest_timer.dart';
import '../domain/set_entry.dart';
import 'register_set_sheet.dart';
import 'session_controller.dart';

class SessionScreen extends ConsumerWidget {
  const SessionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionControllerProvider).value;
    final view = state?.active;
    final controller = ref.read(sessionControllerProvider.notifier);
    if (view == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final ex = view.currentExercise;
    final cursor = view.cursor;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              view.session.weekNumber == null
                  ? view.session.templateName
                  : 'Semana ${view.session.weekNumber} · ${view.session.templateName}',
            ),
            actions: [
              PopupMenuButton<String>(
                onSelected: (v) async {
                  if (v == 'finish') {
                    final ok = await confirmDialog(
                      context,
                      title: 'Encerrar treino?',
                      message: 'As séries registradas ficam salvas.',
                      confirm: 'Encerrar',
                      destructive: true,
                    );
                    if (ok) await controller.finishManually();
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'finish',
                    child: Text('Encerrar treino'),
                  ),
                ],
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text(
                'Próxima série',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                ex.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Série ${cursor.setIndex + 1} de ${ex.sets}'
                '${ex.repsText.isNotEmpty ? ' · ${ex.repsText}' : ''}'
                '${!ex.isWarmup && ex.rir.isNotEmpty ? ' · RIR ${ex.rir}' : ''}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              RestCountdown(restEndsAt: view.session.restEndsAt),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: FilledButton(
                  key: const Key('register-set'),
                  onPressed: () => controller.onRegisterTrigger(),
                  child: Text(
                    'Registrar série',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: view.logs.isEmpty
                          ? null
                          : () async {
                              final ok = await confirmDialog(
                                context,
                                title: 'Desfazer última série?',
                                confirm: 'Desfazer',
                              );
                              if (ok) await controller.undoLast();
                            },
                      icon: const Icon(Icons.undo),
                      label: const Text('Desfazer'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final ok = await confirmDialog(
                          context,
                          title: 'Pular ${ex.name}?',
                          message: 'As séries que faltam deste exercício não serão registradas.',
                          confirm: 'Pular',
                        );
                        if (ok) await controller.skipExercise();
                      },
                      icon: const Icon(Icons.skip_next),
                      label: const Text('Pular'),
                    ),
                  ),
                ],
              ),
              const SectionTitle('Treino'),
              for (var i = 0; i < view.plan.exercises.length; i++)
                _ExerciseRow(
                  name: view.plan.exercises[i].name,
                  done: view.doneSetsOf(i),
                  total: view.plan.exercises[i].sets,
                  current: i == cursor.exerciseIndex,
                  isWarmup: view.plan.exercises[i].isWarmup,
                  detail: view.logs
                      .where((l) => l.exerciseIndex == i)
                      .map(
                        (l) => describeSet(
                          l,
                          view.plan.exercises[i].effectiveLogType,
                        ),
                      )
                      .join(' · '),
                ),
            ],
          ),
        ),
        Positioned.fill(
          child: TopSheetHost(
            data: state?.sheet,
            onConfirm: (entry) => controller.confirmSet(entry),
            onDismiss: controller.closeSheet,
          ),
        ),
      ],
    );
  }
}

class _ExerciseRow extends StatelessWidget {
  const _ExerciseRow({
    required this.name,
    required this.done,
    required this.total,
    required this.current,
    required this.isWarmup,
    required this.detail,
  });

  final String name;
  final int done;
  final int total;
  final bool current;
  final bool isWarmup;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final complete = done >= total;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: current
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.35)
            : const Color(0xFF16171B),
        borderRadius: BorderRadius.circular(14),
        border: current ? Border.all(color: theme.colorScheme.primary) : null,
      ),
      child: Row(
        children: [
          Icon(
            complete
                ? Icons.check_circle
                : (isWarmup ? Icons.self_improvement : Icons.fitness_center),
            color: complete ? Colors.greenAccent : theme.colorScheme.outline,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: theme.textTheme.titleMedium),
                if (detail.isNotEmpty)
                  Text(
                    detail,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
              ],
            ),
          ),
          Text('$done/$total', style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}

/// Contagem regressiva do descanso, calculada pelo horário salvo.
/// O Timer só atualiza a tela enquanto o app está aberto; não há nada
/// rodando em segundo plano.
class RestCountdown extends ConsumerStatefulWidget {
  const RestCountdown({super.key, required this.restEndsAt});
  final DateTime? restEndsAt;

  @override
  ConsumerState<RestCountdown> createState() => _RestCountdownState();
}

class _RestCountdownState extends ConsumerState<RestCountdown> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(RestCountdown old) {
    super.didUpdateWidget(old);
    if (old.restEndsAt != widget.restEndsAt) _sync();
  }

  void _sync() {
    _timer?.cancel();
    _timer = null;
    final now = ref.read(clockProvider)();
    if (RestTimer.isResting(widget.restEndsAt, now)) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() {});
        if (!RestTimer.isResting(
          widget.restEndsAt,
          ref.read(clockProvider)(),
        )) {
          _timer?.cancel();
          _timer = null;
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = RestTimer.remaining(
      widget.restEndsAt,
      ref.read(clockProvider)(),
    );
    if (widget.restEndsAt == null) return const SizedBox.shrink();
    final resting = remaining > Duration.zero;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      decoration: BoxDecoration(
        color: resting ? const Color(0xFF1F2A3A) : const Color(0xFF1E3326),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(resting ? Icons.timer : Icons.check, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              resting ? 'Descanso' : 'Descanso concluído',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge,
            ),
          ),
          if (resting)
            Text(
              formatDuration(
                remaining.inSeconds +
                    (remaining.inMilliseconds % 1000 > 0 ? 1 : 0),
              ),
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
        ],
      ),
    );
  }
}
