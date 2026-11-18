import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/common.dart';
import '../../assessments/domain/assessments.dart';
import '../../blocks/domain/block_generator.dart';
import '../../home/presentation/home_providers.dart';
import '../data/dashboard_repository.dart';
import '../domain/dashboard_calc.dart';

// Paleta validada para o fundo escuro (CVD ΔE 26 entre as duas séries).
const _blue = Color(0xFF3987E5);
const _orange = Color(0xFFD95926);
const _grid = Color(0xFF2C2C2A);
const _muted = Color(0xFF898781);
const _ink = Color(0xFFF0EFEC);

/// -1 = todos os blocos; null = ainda não escolhido (usa o bloco ativo).
class DashboardFilter extends Notifier<int?> {
  @override
  int? build() => null;
  void set(int? v) => state = v;
}

final dashboardFilterProvider = NotifierProvider<DashboardFilter, int?>(
  DashboardFilter.new,
);

final _dashboardProvider = FutureProvider.autoDispose<DashboardData>((
  ref,
) async {
  ref.watch(dataVersionProvider);
  final filter = ref.watch(dashboardFilterProvider);
  final repo = DashboardRepository(ref.watch(databaseProvider));
  int? blockId = filter;
  if (filter == null) {
    blockId = (await ref.watch(blockRepositoryProvider).activeBlock())?.id;
  } else if (filter == -1) {
    blockId = null;
  }
  return repo.load(blockId: blockId);
});

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int? _exerciseId;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(_dashboardProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (d) => _body(context, d),
      ),
    );
  }

  Widget _body(BuildContext context, DashboardData d) {
    final theme = Theme.of(context);
    final exercise =
        d.exercises.where((e) => e.id == _exerciseId).firstOrNull ??
        d.exercises.firstOrNull;
    final e1 = exercise == null
        ? <E1rmPoint>[]
        : e1rmSeries(exercise.id, d.sessions, d.logs);
    final volume = weeklyVolume(d.sessions, d.logs);
    final templates = <String>{
      for (final w in volume) ...w.volumeByTemplate.keys,
    }.toList()..sort();
    final adherenceBlock =
        d.block ?? d.blocks.where((b) => b.isActive).firstOrNull;
    final adh = adherenceBlock == null
        ? <WeekAdherence>[]
        : adherence(
            block: adherenceBlock,
            planned: d.planned,
            sessions: d.sessions,
            cardio: d.cardio,
          );
    final currentWeek = adherenceBlock == null
        ? 0
        : (blockWeekFor(
                startDate: adherenceBlock.startDate,
                weeks: adherenceBlock.weeks,
                date: DateTime.now(),
              ) ??
              (DateTime.now().isBefore(adherenceBlock.startDate)
                  ? 0
                  : adherenceBlock.weeks));
    final km = kmPerWeek(d.cardio);
    final run = runStats(d.cardio);
    final cond = conditioningPerWeek(d.cardio);
    final filter = ref.watch(dashboardFilterProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
      children: [
        DropdownButtonFormField<int>(
          initialValue: filter ?? d.block?.id ?? -1,
          decoration: const InputDecoration(labelText: 'Bloco'),
          items: [
            const DropdownMenuItem(value: -1, child: Text('Todos os blocos')),
            for (final b in d.blocks)
              DropdownMenuItem(value: b.id, child: Text(b.name)),
          ],
          onChanged: (v) => ref.read(dashboardFilterProvider.notifier).set(v),
        ),

        // ---------- 1. Força ----------
        const SectionTitle('Força · 1RM estimado (Epley)'),
        if (exercise == null)
          const EmptyHint('Sem séries com carga ainda.')
        else ...[
          DropdownButtonFormField<int>(
            initialValue: exercise.id,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Exercício'),
            items: [
              for (final e in d.exercises)
                DropdownMenuItem(value: e.id, child: Text(e.name)),
            ],
            onChanged: (v) => setState(() => _exerciseId = v),
          ),
          const SizedBox(height: 12),
          _ChartCard(
            child: _LineSeries(
              labels: [for (final p in e1) formatShortDate(p.date)],
              values: [for (final p in e1) p.e1rm],
              highlight: {
                for (var i = 0; i < e1.length; i++)
                  if (e1[i].isE1rmPr || e1[i].isLoadPr) i,
              },
              unit: 'kg',
            ),
          ),
          if (e1.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(
                spacing: 16,
                runSpacing: 4,
                children: [
                  _Stat(
                    'Melhor 1RM est.',
                    '${formatNumber(e1.map((p) => p.e1rm).reduce(math.max))} kg',
                  ),
                  _Stat(
                    'Maior carga',
                    '${formatNumber(e1.map((p) => p.bestLoad).reduce(math.max))} kg',
                  ),
                  _Stat(
                    'PRs',
                    '${e1.where((p) => p.isE1rmPr || p.isLoadPr).length}',
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Pontos maiores = recorde (carga ou 1RM estimado).',
              style: theme.textTheme.bodySmall?.copyWith(color: _muted),
            ),
          ),
        ],

        // ---------- 2. Volume ----------
        const SectionTitle('Volume semanal (kg × reps)'),
        if (volume.isEmpty)
          const EmptyHint('Sem treinos de força ainda.')
        else ...[
          _Legend([
            for (var i = 0; i < templates.length && i < 2; i++)
              (templates[i], i == 0 ? _blue : _orange),
          ]),
          _ChartCard(
            child: _Bars(
              labels: [for (final w in volume) formatShortDate(w.weekStart)],
              series: [
                for (var i = 0; i < templates.length && i < 2; i++)
                  [
                    for (final w in volume)
                      w.volumeByTemplate[templates[i]] ?? 0,
                  ],
              ],
              colors: const [_blue, _orange],
              seriesNames: templates.take(2).toList(),
              unit: 'kg',
            ),
          ),
          const SizedBox(height: 8),
          Text('Séries efetivas por semana', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          _ChartCard(
            height: 160,
            child: _Bars(
              labels: [for (final w in volume) formatShortDate(w.weekStart)],
              series: [
                [for (final w in volume) w.effectiveSets.toDouble()],
              ],
              colors: const [_blue],
              seriesNames: const ['Séries'],
              unit: 'séries',
            ),
          ),
        ],

        // ---------- 3. Aderência ----------
        SectionTitle(
          'Aderência${adherenceBlock == null ? '' : ' · ${adherenceBlock.name}'}',
        ),
        if (adh.isEmpty)
          const EmptyHint('Nenhum bloco para medir aderência.')
        else ...[
          _Stat(
            'Sequência de semanas cumpridas',
            '${fulfilledStreak(adh, currentWeek)}',
          ),
          const SizedBox(height: 8),
          _ChartCard(
            height: 170,
            child: _Bars(
              labels: [for (final a in adh) 'S${a.week}'],
              series: [
                [for (final a in adh) a.ratio * 100],
              ],
              colors: const [_blue],
              seriesNames: const ['Aderência'],
              unit: '%',
              maxY: 100,
              tooltip: (i, _) =>
                  'S${adh[i].week}: ${adh[i].done}/${adh[i].planned} sessões',
            ),
          ),
        ],

        // ---------- 4. Corrida ----------
        const SectionTitle('Corrida'),
        if (km.isEmpty)
          const EmptyHint('Sem corridas registradas.')
        else ...[
          Wrap(
            spacing: 16,
            runSpacing: 4,
            children: [
              _Stat(
                'Maior tempo contínuo',
                run.longestSec == null ? '–' : formatDuration(run.longestSec!),
              ),
              _Stat(
                'Total',
                '${formatNumber(km.fold<double>(0, (s, w) => s + w.value))} km',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('km por semana', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          _ChartCard(
            height: 170,
            child: _Bars(
              labels: [for (final w in km) formatShortDate(w.weekStart)],
              series: [
                [for (final w in km) w.value],
              ],
              colors: const [_blue],
              seriesNames: const ['km'],
              unit: 'km',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Pace (min/km) — menor é melhor',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          _ChartCard(
            child: _LineSeries(
              labels: [for (final p in run.paceTrend) formatShortDate(p.$1)],
              values: [for (final p in run.paceTrend) p.$2.toDouble()],
              formatY: (v) => formatDuration(v.round()),
              unit: 'min/km',
            ),
          ),
          const SizedBox(height: 12),
          Text('Melhor pace por distância', style: theme.textTheme.titleSmall),
          for (final band in distanceBands)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(band.$1, style: theme.textTheme.bodyLarge),
              trailing: Text(
                formatPace(run.bestPaceByBand[band.$1]),
                style: theme.textTheme.titleMedium,
              ),
            ),
        ],

        // ---------- 5. Condicionamento ----------
        const SectionTitle('Condicionamento'),
        if (cond.isEmpty)
          const EmptyHint('Sem EMOM/Cross registrados.')
        else ...[
          Text('Minutos por semana', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          _ChartCard(
            height: 170,
            child: _Bars(
              labels: [for (final w in cond) formatShortDate(w.weekStart)],
              series: [
                [for (final w in cond) w.value],
              ],
              colors: const [_blue],
              seriesNames: const ['Minutos'],
              unit: 'min',
              tooltip: (i, v) =>
                  '${formatNumber(v)} min · RPE médio ${formatNumber(cond[i].secondary)}',
            ),
          ),
          const SizedBox(height: 8),
          for (final w in cond.reversed.take(4))
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text('Semana de ${formatShortDate(w.weekStart)}'),
              trailing: Text(
                '${formatNumber(w.value)} min · RPE ${formatNumber(w.secondary)}',
                style: theme.textTheme.titleMedium,
              ),
            ),
        ],

        // ---------- 6. Testes ----------
        const SectionTitle('Testes · semana 1 × última'),
        _AssessmentTable(
          rows: compareWeeks(d.assessments, 1, adherenceBlock?.weeks ?? 8),
          lastWeek: adherenceBlock?.weeks ?? 8,
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodySmall?.copyWith(color: _muted)),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend(this.items);
  final List<(String, Color)> items;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Wrap(
      spacing: 16,
      children: [
        for (final i in items)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: i.$2,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 6),
              Text(i.$1, style: const TextStyle(color: _ink)),
            ],
          ),
      ],
    ),
  );
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.child, this.height = 220});
  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
      child: SizedBox(height: height, child: child),
    ),
  );
}

const _axisStyle = TextStyle(color: _muted, fontSize: 11);

FlTitlesData _titles(List<String> labels, String Function(double) formatY) {
  final step = math.max(1, (labels.length / 6).ceil());
  return FlTitlesData(
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 44,
        getTitlesWidget: (v, meta) {
          if (v == meta.max || v == meta.min && v != 0) {
            return const SizedBox.shrink();
          }
          return SideTitleWidget(
            meta: meta,
            child: Text(formatY(v), style: _axisStyle),
          );
        },
      ),
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 24,
        interval: 1,
        getTitlesWidget: (v, meta) {
          final i = v.round();
          if (i < 0 || i >= labels.length || i % step != 0 || v != i) {
            return const SizedBox.shrink();
          }
          return SideTitleWidget(
            meta: meta,
            child: Text(labels[i], style: _axisStyle),
          );
        },
      ),
    ),
  );
}

FlGridData get _gridData => FlGridData(
  drawVerticalLine: false,
  getDrawingHorizontalLine: (_) => const FlLine(color: _grid, strokeWidth: 1),
);

class _LineSeries extends StatelessWidget {
  const _LineSeries({
    required this.labels,
    required this.values,
    this.highlight = const {},
    this.formatY,
    required this.unit,
  });

  final List<String> labels;
  final List<double> values;
  final Set<int> highlight;
  final String Function(double)? formatY;
  final String unit;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const Center(child: Text('Sem dados'));
    final fmt = formatY ?? (v) => formatNumber(v);
    final minV = values.reduce(math.min);
    final maxV = values.reduce(math.max);
    final pad = math.max((maxV - minV) * 0.15, maxV * 0.05 + 1);
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: math.max(1, values.length - 1).toDouble(),
        minY: math.max(0, minV - pad),
        maxY: maxV + pad,
        gridData: _gridData,
        borderData: FlBorderData(
          show: true,
          border: const Border(bottom: BorderSide(color: Color(0xFF383835))),
        ),
        titlesData: _titles(labels, fmt),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => const Color(0xFF2A2B30),
            getTooltipItems: (spots) => [
              for (final s in spots)
                LineTooltipItem(
                  '${labels[s.x.round()]}\n${fmt(s.y)} $unit',
                  const TextStyle(color: _ink, fontWeight: FontWeight.w600),
                ),
            ],
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < values.length; i++)
                FlSpot(i.toDouble(), values[i]),
            ],
            color: _blue,
            barWidth: 2,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, _, _, i) => FlDotCirclePainter(
                radius: highlight.contains(i) ? 6.5 : 4,
                color: highlight.contains(i) ? _orange : _blue,
                strokeWidth: 2,
                strokeColor: const Color(0xFF1A1B1F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bars extends StatelessWidget {
  const _Bars({
    required this.labels,
    required this.series,
    required this.colors,
    required this.seriesNames,
    required this.unit,
    this.maxY,
    this.tooltip,
  });

  final List<String> labels;
  final List<List<double>> series;
  final List<Color> colors;
  final List<String> seriesNames;
  final String unit;
  final double? maxY;
  final String Function(int index, double value)? tooltip;

  @override
  Widget build(BuildContext context) {
    if (labels.isEmpty || series.isEmpty) {
      return const Center(child: Text('Sem dados'));
    }
    final width = math.max(
      6.0,
      math.min(18.0, 220 / (labels.length * series.length)),
    );
    return BarChart(
      BarChartData(
        maxY: maxY,
        gridData: _gridData,
        borderData: FlBorderData(
          show: true,
          border: const Border(bottom: BorderSide(color: Color(0xFF383835))),
        ),
        titlesData: _titles(labels, (v) => formatNumber(v, maxDecimals: 0)),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => const Color(0xFF2A2B30),
            getTooltipItem: (group, gi, rod, ri) => BarTooltipItem(
              tooltip?.call(gi, rod.toY) ??
                  '${labels[gi]}${series.length > 1 ? ' · ${seriesNames[ri]}' : ''}\n${formatNumber(rod.toY)} $unit',
              const TextStyle(color: _ink, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < labels.length; i++)
            BarChartGroupData(
              x: i,
              barsSpace: 2,
              barRods: [
                for (var s = 0; s < series.length; s++)
                  BarChartRodData(
                    toY: series[s][i],
                    color: colors[s],
                    width: width,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _AssessmentTable extends StatelessWidget {
  const _AssessmentTable({required this.rows, required this.lastWeek});
  final List<AssessmentComparison> rows;
  final int lastWeek;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (rows.every((r) => r.before == null && r.after == null)) {
      return const EmptyHint('Sem testes registrados neste bloco.');
    }
    Widget cell(String t, {Color? color, bool header = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        t,
        textAlign: TextAlign.right,
        style:
            (header ? theme.textTheme.titleSmall : theme.textTheme.titleMedium)
                ?.copyWith(color: color),
      ),
    );
    return Table(
      columnWidths: const {0: FlexColumnWidth(2.4)},
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            const SizedBox(),
            cell('S1', header: true),
            cell('S$lastWeek', header: true),
            cell('Dif.', header: true),
          ],
        ),
        for (final r in rows)
          TableRow(
            children: [
              Text(
                '${r.def.label} (${r.def.unit})',
                style: theme.textTheme.bodyLarge,
              ),
              cell(formatNumber(r.before)),
              cell(formatNumber(r.after)),
              // Diferença sempre com texto e sinal; a cor é só reforço.
              cell(
                r.diff == null
                    ? '–'
                    : '${r.diff! > 0 ? '+' : ''}${formatNumber(r.diff)}',
              ),
            ],
          ),
      ],
    );
  }
}
