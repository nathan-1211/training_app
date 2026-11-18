import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format.dart';
import '../domain/session_summary.dart';
import 'session_controller.dart';

class SummaryScreen extends ConsumerWidget {
  const SummaryScreen({super.key, required this.summary});
  final SessionSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    Widget stat(String label, String value) => Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Treino encerrado'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            summary.templateName,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              stat('Duração', formatDuration(summary.duration.inSeconds)),
              const SizedBox(width: 12),
              stat('Séries', '${summary.setCount}'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              stat('Volume total', '${formatNumber(summary.totalVolumeKg)} kg'),
            ],
          ),
          const SizedBox(height: 24),
          Text('Recordes do dia', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          if (summary.records.isEmpty)
            Text(
              'Nenhum recorde hoje. Consistência também conta.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          for (final r in summary.records)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.emoji_events,
                color: Colors.amber,
                size: 32,
              ),
              title: Text(r.exerciseName),
              subtitle: Text(
                'PR de ${r.kind}: ${formatNumber(r.value)} kg (antes ${formatNumber(r.previous)} kg)',
              ),
            ),
          const SizedBox(height: 32),
          FilledButton(
            key: const Key('summary-done'),
            onPressed: () =>
                ref.read(sessionControllerProvider.notifier).dismissSummary(),
            child: const Text('Concluir'),
          ),
        ],
      ),
    );
  }
}
