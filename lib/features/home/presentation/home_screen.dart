import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums.dart';
import '../../../core/format.dart';
import '../../assessments/presentation/assessments_screen.dart';
import '../../blocks/data/block_repository.dart';
import '../../blocks/presentation/blocks_screen.dart';
import '../../cardio/presentation/cardio_form_screen.dart';
import '../../dashboard/presentation/dashboard_screen.dart';
import '../../session/presentation/session_controller.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../trigger/presentation/double_tap_setup_screen.dart';
import 'home_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _push(BuildContext context, Widget screen) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));

  Future<void> _chooseWorkout(BuildContext context, WidgetRef ref) async {
    final templates = await ref.read(activeTemplatesProvider.future);
    if (!context.mounted) return;
    if (templates.isEmpty) return;
    final id = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Escolher treino', style: TextStyle(fontSize: 20)),
            ),
            for (final t in templates)
              ListTile(
                title: Text(t.name, style: const TextStyle(fontSize: 20)),
                trailing: const Icon(Icons.play_arrow),
                onTap: () => Navigator.pop(ctx, t.id),
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
    if (id != null) {
      await ref.read(sessionControllerProvider.notifier).start(id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(todayPlanProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treino'),
        actions: [
          IconButton(
            tooltip: 'Configurações',
            iconSize: 30,
            icon: const Icon(Icons.settings),
            onPressed: () => _push(context, const SettingsScreen()),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          plan.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('Erro: $e'),
            data: (p) => _TodayCard(
              plan: p,
              onStart: (templateId) => ref
                  .read(sessionControllerProvider.notifier)
                  .start(templateId),
              onRun: () =>
                  _push(context, const CardioFormScreen(type: CardioType.run)),
              onConditioning: () =>
                  _push(context, const CardioFormScreen(type: CardioType.emom)),
              onTests: () => _push(context, const AssessmentsScreen()),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _chooseWorkout(context, ref),
            icon: const Icon(Icons.list),
            label: const Text('Escolher outro treino'),
          ),
          const SizedBox(height: 24),
          GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 124,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _Tile(
                Icons.directions_run,
                'Registrar corrida',
                () => _push(
                  context,
                  const CardioFormScreen(type: CardioType.run),
                ),
              ),
              _Tile(
                Icons.timer,
                'EMOM / Cross',
                () => _push(
                  context,
                  const CardioFormScreen(type: CardioType.emom),
                ),
              ),
              _Tile(
                Icons.insights,
                'Dashboard',
                () => _push(context, const DashboardScreen()),
              ),
              _Tile(
                Icons.flag,
                'Testes',
                () => _push(context, const AssessmentsScreen()),
              ),
              _Tile(
                Icons.view_week,
                'Blocos',
                () => _push(context, const BlocksScreen()),
              ),
              _Tile(
                Icons.touch_app,
                'Configurar toque duplo',
                () => _push(context, const DoubleTapSetupScreen()),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            formatDate(DateTime.now()),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({
    required this.plan,
    required this.onStart,
    required this.onRun,
    required this.onConditioning,
    required this.onTests,
  });

  final DayPlan? plan;
  final ValueChanged<int> onStart;
  final VoidCallback onRun;
  final VoidCallback onConditioning;
  final VoidCallback onTests;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = plan;
    final today = DateTime.now();
    final weekdayLabel = '${weekdayNames[today.weekday]}, ${formatDate(today)}';

    String title;
    String? subtitle;
    Widget? action;
    if (p == null) {
      title = 'Nenhum bloco ativo';
      subtitle = 'Cadastre ou ative um bloco em "Blocos".';
    } else if (p.week == null) {
      title = p.block.name;
      subtitle = today.isBefore(p.block.startDate)
          ? 'O bloco começa em ${formatDate(p.block.startDate)}.'
          : 'O bloco terminou. Escolha um treino ou crie o próximo bloco.';
    } else {
      final weekLabel = 'Semana ${p.week}';
      final phase = p.weekRow?.phase ?? '';
      switch (p.kind) {
        case DayKind.strength:
          title = '$weekLabel · ${p.template?.name ?? 'Força'}';
          subtitle = phase.isEmpty
              ? null
              : '$phase · ${p.weekRow!.mainSets} séries · RIR ${p.weekRow!.rir}';
          if (p.template != null) {
            action = SizedBox(
              height: 84,
              child: FilledButton.icon(
                key: const Key('start-workout'),
                onPressed: () => onStart(p.template!.id),
                icon: const Icon(Icons.play_arrow, size: 36),
                label: const Text(
                  'Iniciar treino',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            );
          }
        case DayKind.run:
          title = '$weekLabel · Corrida';
          subtitle = p.weekRow?.runPrescription;
          action = FilledButton.icon(
            onPressed: onRun,
            icon: const Icon(Icons.directions_run),
            label: const Text('Registrar corrida'),
          );
        case DayKind.conditioning:
          title = '$weekLabel · Condicionamento';
          subtitle = p.weekRow?.conditioningPrescription;
          final testWeek = p.week == 1 || p.week == p.block.weeks;
          action = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.icon(
                onPressed: onConditioning,
                icon: const Icon(Icons.timer),
                label: const Text('Registrar condicionamento'),
              ),
              if (testWeek) ...[
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: onTests,
                  icon: const Icon(Icons.flag),
                  label: const Text('Registrar testes'),
                ),
              ],
            ],
          );
        case DayKind.rest:
          title = '$weekLabel · Descanso';
          subtitle = phase.isEmpty ? 'Dia livre.' : '$phase · dia livre.';
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              weekdayLabel,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              key: const Key('today-title'),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            if (subtitle != null && subtitle.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(subtitle, style: theme.textTheme.titleMedium),
            ],
            if (action != null) ...[const SizedBox(height: 20), action],
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                size: 30,
                color: Theme.of(context).colorScheme.primary,
              ),
              Flexible(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
