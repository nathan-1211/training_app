import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/format.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/common.dart';
import '../../blocks/domain/block_generator.dart';
import '../../home/presentation/home_providers.dart';
import '../data/assessment_repository.dart';
import '../domain/assessments.dart';

final assessmentRepositoryProvider = Provider(
  (ref) => AssessmentRepository(ref.watch(databaseProvider)),
);

final _assessmentDataProvider =
    FutureProvider.autoDispose<
      ({Block? block, int? currentWeek, List<AssessmentResult> results})
    >((ref) async {
      ref.watch(dataVersionProvider);
      final block = await ref.watch(blockRepositoryProvider).activeBlock();
      final week = block == null
          ? null
          : blockWeekFor(
              startDate: block.startDate,
              weeks: block.weeks,
              date: DateTime.now(),
            );
      final results = await ref
          .watch(assessmentRepositoryProvider)
          .ofBlock(block?.id);
      return (block: block, currentWeek: week, results: results);
    });

class AssessmentsScreen extends ConsumerStatefulWidget {
  const AssessmentsScreen({super.key});

  @override
  ConsumerState<AssessmentsScreen> createState() => _AssessmentsScreenState();
}

class _AssessmentsScreenState extends ConsumerState<AssessmentsScreen> {
  final _controllers = {
    for (final d in assessmentDefs) d.key: TextEditingController(),
  };
  int? _week;

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save(Block? block, int week) async {
    final values = <String, double>{};
    for (final d in assessmentDefs) {
      final v = parseDecimal(_controllers[d.key]!.text);
      if (v != null) values[d.key] = v;
    }
    if (values.isEmpty) {
      showSnack(context, 'Preencha pelo menos um teste');
      return;
    }
    await ref
        .read(assessmentRepositoryProvider)
        .saveAll(
          blockId: block?.id,
          week: week,
          date: DateTime.now(),
          values: values,
        );
    for (final c in _controllers.values) {
      c.clear();
    }
    ref.read(dataVersionProvider.notifier).bump();
    if (mounted) showSnack(context, 'Testes salvos (semana $week)');
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(_assessmentDataProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Testes')),
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (d) {
          final lastWeek = d.block?.weeks ?? 8;
          final week =
              _week ?? ((d.currentWeek ?? 1) >= lastWeek ? lastWeek : 1);
          final comparison = compareWeeks(d.results, 1, lastWeek);
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text('Registrar', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              SegmentedButton<int>(
                segments: [
                  const ButtonSegment(value: 1, label: Text('Semana 1')),
                  ButtonSegment(
                    value: lastWeek,
                    label: Text('Semana $lastWeek'),
                  ),
                ],
                selected: {week},
                onSelectionChanged: (s) => setState(() => _week = s.first),
              ),
              const SizedBox(height: 16),
              for (final def in assessmentDefs)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: NumberField(
                    controller: _controllers[def.key]!,
                    label: def.label,
                    suffix: def.unit,
                    decimal: def.decimal,
                  ),
                ),
              FilledButton(
                onPressed: () => _save(d.block, week),
                child: const Text('Salvar testes'),
              ),
              SectionTitle('Semana 1 × Semana $lastWeek'),
              Table(
                columnWidths: const {0: FlexColumnWidth(2.4)},
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      const SizedBox(),
                      _cell(context, 'S1', header: true),
                      _cell(context, 'S$lastWeek', header: true),
                      _cell(context, 'Dif.', header: true),
                    ],
                  ),
                  for (final c in comparison)
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            '${c.def.label} (${c.def.unit})',
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                        _cell(context, formatNumber(c.before)),
                        _cell(context, formatNumber(c.after)),
                        _cell(
                          context,
                          c.diff == null
                              ? '–'
                              : '${c.diff! > 0 ? '+' : ''}${formatNumber(c.diff)}',
                          color: c.diff == null || c.diff == 0
                              ? null
                              : (c.diff! > 0
                                    ? Colors.greenAccent
                                    : Colors.redAccent),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _cell(
    BuildContext context,
    String text, {
    bool header = false,
    Color? color,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(
      text,
      textAlign: TextAlign.right,
      style:
          (header
                  ? Theme.of(context).textTheme.titleSmall
                  : Theme.of(context).textTheme.titleMedium)
              ?.copyWith(color: color),
    ),
  );
}
