import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums.dart';
import '../../../core/format.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/common.dart';
import '../../home/presentation/home_providers.dart';
import '../domain/block_spec.dart';

/// Criar (blockId == null) ou editar um bloco.
class BlockEditorScreen extends ConsumerStatefulWidget {
  const BlockEditorScreen({super.key, this.blockId, required this.initial});
  final int? blockId;
  final BlockSpec? initial;

  @override
  ConsumerState<BlockEditorScreen> createState() => _BlockEditorScreenState();
}

class _BlockEditorScreenState extends ConsumerState<BlockEditorScreen> {
  late final BlockSpec spec = widget.initial!..normalizeWeeks();
  late final _name = TextEditingController(text: spec.name);
  bool _saving = false;

  bool get _isNew => widget.blockId == null;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    spec.name = _name.text.trim();
    if (spec.name.isEmpty) {
      showSnack(context, 'Dê um nome ao bloco');
      return;
    }
    if (spec.workouts.any((w) => w.name.trim().isEmpty)) {
      showSnack(context, 'Todos os treinos precisam de nome');
      return;
    }
    setState(() => _saving = true);
    final repo = ref.read(blockRepositoryProvider);
    if (_isNew) {
      await repo.createFromSpec(spec, activate: true);
    } else {
      await repo.updateFromSpec(widget.blockId!, spec);
    }
    ref.read(dataVersionProvider.notifier).bump();
    if (!mounted) return;
    showSnack(context, _isNew ? 'Bloco gerado e ativado' : 'Bloco atualizado');
    Navigator.pop(context);
  }

  Future<void> _pickStart() async {
    final d = await showDatePicker(
      context: context,
      initialDate: spec.startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => spec.startDate = d);
  }

  Future<void> _editExercise(WorkoutSpec w, int? index) async {
    final result = await Navigator.of(context).push<ExerciseSpec>(
      MaterialPageRoute(
        builder: (_) => ExerciseEditScreen(
          initial: index == null ? null : w.exercises[index],
        ),
      ),
    );
    if (result == null) return;
    setState(() {
      if (index == null) {
        w.exercises.add(result);
      } else {
        w.exercises[index] = result;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(_isNew ? 'Cadastrar bloco' : 'Editar bloco')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          TextField(
            controller: _name,
            style: theme.textTheme.titleLarge,
            decoration: const InputDecoration(labelText: 'Nome do bloco'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickStart,
            icon: const Icon(Icons.event),
            label: Text('Início: ${formatDate(spec.startDate)}'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Semanas', style: theme.textTheme.titleMedium),
              const Spacer(),
              IconButton.filledTonal(
                iconSize: 28,
                onPressed: spec.weeks > 1
                    ? () => setState(() {
                        spec.weeks--;
                        spec.normalizeWeeks();
                      })
                    : null,
                icon: const Icon(Icons.remove),
              ),
              SizedBox(
                width: 56,
                child: Text(
                  '${spec.weeks}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              IconButton.filledTonal(
                iconSize: 28,
                onPressed: spec.weeks < 16
                    ? () => setState(() {
                        spec.weeks++;
                        spec.normalizeWeeks();
                      })
                    : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),

          // ---------------- Treinos ----------------
          const SectionTitle('Treinos'),
          for (var wi = 0; wi < spec.workouts.length; wi++)
            _WorkoutCard(
              key: ObjectKey(spec.workouts[wi]),
              workout: spec.workouts[wi],
              onChanged: () => setState(() {}),
              onEditExercise: (i) => _editExercise(spec.workouts[wi], i),
              onDelete: spec.workouts.length > 1
                  ? () async {
                      final ok = await confirmDialog(
                        context,
                        title: 'Remover ${spec.workouts[wi].name}?',
                        destructive: true,
                        confirm: 'Remover',
                      );
                      if (ok) setState(() => spec.removeWorkout(wi));
                    }
                  : null,
            ),
          OutlinedButton.icon(
            onPressed: () => setState(
              () => spec.workouts.add(
                WorkoutSpec(
                  name:
                      'Força ${String.fromCharCode(65 + spec.workouts.length)}',
                ),
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Adicionar treino'),
          ),

          // ---------------- Agenda ----------------
          const SectionTitle('Agenda semanal'),
          for (var wd = 1; wd <= 7; wd++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 96,
                    child: Text(
                      weekdayNames[wd]!,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      key: ValueKey('day-$wd-${spec.workouts.length}'),
                      initialValue: _dayValue(spec.dayFor(wd)),
                      isExpanded: true,
                      items: [
                        for (final o in _dayOptions())
                          DropdownMenuItem(value: o.$1, child: Text(o.$2)),
                      ],
                      onChanged: (v) =>
                          setState(() => spec.schedule[wd] = _parseDay(v!)),
                    ),
                  ),
                ],
              ),
            ),

          // ---------------- Progressão ----------------
          const SectionTitle('Progressão por semana'),
          Text(
            'Séries valem para os exercícios principais; aquecimentos têm séries fixas.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          for (final w in spec.weekSpecs)
            _WeekCard(
              key: ObjectKey(w),
              week: w,
              onChanged: () => setState(() {}),
            ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.auto_awesome),
            label: Text(_isNew ? 'Gerar bloco' : 'Salvar e regenerar'),
          ),
          if (!_isNew)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'As sessões planejadas são regeneradas. Treinos já feitos não mudam.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }

  List<(String, String)> _dayOptions() => [
    ('rest', 'Descanso'),
    ('run', 'Corrida'),
    ('conditioning', 'Condicionamento'),
    for (var i = 0; i < spec.workouts.length; i++)
      (
        'w$i',
        spec.workouts[i].name.isEmpty
            ? 'Treino ${i + 1}'
            : spec.workouts[i].name,
      ),
  ];

  String _dayValue(DaySpec d) => switch (d.kind) {
    DayKind.strength => 'w${d.workoutIndex ?? 0}',
    DayKind.run => 'run',
    DayKind.conditioning => 'conditioning',
    DayKind.rest => 'rest',
  };

  DaySpec _parseDay(String v) => switch (v) {
    'run' => const DaySpec(kind: DayKind.run),
    'conditioning' => const DaySpec(kind: DayKind.conditioning),
    'rest' => const DaySpec.rest(),
    _ => DaySpec(
      kind: DayKind.strength,
      workoutIndex: int.parse(v.substring(1)),
    ),
  };
}

class _WorkoutCard extends StatefulWidget {
  const _WorkoutCard({
    super.key,
    required this.workout,
    required this.onChanged,
    required this.onEditExercise,
    required this.onDelete,
  });

  final WorkoutSpec workout;
  final VoidCallback onChanged;
  final ValueChanged<int?> onEditExercise;
  final VoidCallback? onDelete;

  @override
  State<_WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<_WorkoutCard> {
  late final _name = TextEditingController(text: widget.workout.name);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _move(int from, int to) {
    final list = widget.workout.exercises;
    final e = list.removeAt(from);
    list.insert(to, e);
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.workout;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: ExpansionTile(
          shape: const Border(),
          title: TextField(
            controller: _name,
            style: Theme.of(context).textTheme.titleLarge,
            decoration: const InputDecoration(
              labelText: 'Nome do treino',
              filled: false,
              border: InputBorder.none,
            ),
            onChanged: (v) {
              w.name = v;
              widget.onChanged();
            },
          ),
          subtitle: Text('${w.exercises.length} exercícios'),
          children: [
            for (var i = 0; i < w.exercises.length; i++)
              ListTile(
                onTap: () => widget.onEditExercise(i),
                leading: Icon(
                  w.exercises[i].isWarmup
                      ? Icons.self_improvement
                      : Icons.fitness_center,
                ),
                title: Text(w.exercises[i].name),
                subtitle: Text(
                  [
                    w.exercises[i].logType.label,
                    if (w.exercises[i].repsText.isNotEmpty)
                      w.exercises[i].repsText,
                    if (w.exercises[i].restSec > 0)
                      '${w.exercises[i].restSec}s',
                    if (w.exercises[i].fixedSets != null)
                      '${w.exercises[i].fixedSets} séries fixas',
                  ].join(' · '),
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'up' && i > 0) _move(i, i - 1);
                    if (v == 'down' && i < w.exercises.length - 1) {
                      _move(i, i + 1);
                    }
                    if (v == 'delete') {
                      w.exercises.removeAt(i);
                      widget.onChanged();
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'up', child: Text('Mover para cima')),
                    PopupMenuItem(
                      value: 'down',
                      child: Text('Mover para baixo'),
                    ),
                    PopupMenuItem(value: 'delete', child: Text('Remover')),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => widget.onEditExercise(null),
                      icon: const Icon(Icons.add),
                      label: const Text('Exercício'),
                    ),
                  ),
                  if (widget.onDelete != null) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: 'Remover treino',
                      onPressed: widget.onDelete,
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekCard extends StatefulWidget {
  const _WeekCard({super.key, required this.week, required this.onChanged});
  final WeekSpec week;
  final VoidCallback onChanged;

  @override
  State<_WeekCard> createState() => _WeekCardState();
}

class _WeekCardState extends State<_WeekCard> {
  late final _phase = TextEditingController(text: widget.week.phase);
  late final _rir = TextEditingController(text: widget.week.rir);
  late final _run = TextEditingController(text: widget.week.run);
  late final _cond = TextEditingController(text: widget.week.conditioning);

  @override
  void dispose() {
    _phase.dispose();
    _rir.dispose();
    _run.dispose();
    _cond.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.week;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: ExpansionTile(
          shape: const Border(),
          title: Text(
            'Semana ${w.week}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            '${w.phase.isEmpty ? '' : '${w.phase} · '}${w.mainSets} séries · RIR ${w.rir.isEmpty ? '–' : w.rir}',
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            TextField(
              controller: _phase,
              decoration: const InputDecoration(labelText: 'Fase'),
              onChanged: (v) {
                w.phase = v;
                widget.onChanged();
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: w.mainSets,
                    decoration: const InputDecoration(labelText: 'Séries'),
                    items: [
                      for (var i = 1; i <= 8; i++)
                        DropdownMenuItem(value: i, child: Text('$i')),
                    ],
                    onChanged: (v) {
                      w.mainSets = v!;
                      widget.onChanged();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _rir,
                    decoration: const InputDecoration(labelText: 'RIR'),
                    onChanged: (v) {
                      w.rir = v;
                      widget.onChanged();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _run,
              decoration: const InputDecoration(labelText: 'Corrida'),
              onChanged: (v) => w.run = v,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _cond,
              decoration: const InputDecoration(labelText: 'Condicionamento'),
              onChanged: (v) => w.conditioning = v,
            ),
          ],
        ),
      ),
    );
  }
}

/// Edita um exercício do treino.
class ExerciseEditScreen extends StatefulWidget {
  const ExerciseEditScreen({super.key, this.initial});
  final ExerciseSpec? initial;

  @override
  State<ExerciseEditScreen> createState() => _ExerciseEditScreenState();
}

class _ExerciseEditScreenState extends State<ExerciseEditScreen> {
  late final e = widget.initial;
  late final _name = TextEditingController(text: e?.name ?? '');
  late final _reps = TextEditingController(text: e?.repsText ?? '');
  late final _min = TextEditingController(text: e?.repsMin?.toString() ?? '');
  late final _max = TextEditingController(text: e?.repsMax?.toString() ?? '');
  late final _rest = TextEditingController(text: (e?.restSec ?? 90).toString());
  late final _tip = TextEditingController(text: e?.tip ?? '');
  late final _fixed = TextEditingController(
    text: e?.fixedSets?.toString() ?? '',
  );
  late LogType _type = e?.logType ?? LogType.loadReps;
  late bool _warmup = e?.isWarmup ?? false;

  @override
  void dispose() {
    for (final c in [_name, _reps, _min, _max, _rest, _tip, _fixed]) {
      c.dispose();
    }
    super.dispose();
  }

  void _autoRange(String text) {
    final r = parseRepsRange(text);
    _min.text = r.min?.toString() ?? '';
    _max.text = r.max?.toString() ?? '';
  }

  void _done() {
    if (_name.text.trim().isEmpty) {
      showSnack(context, 'Informe o nome');
      return;
    }
    Navigator.pop(
      context,
      ExerciseSpec(
        name: _name.text.trim(),
        logType: _warmup ? LogType.confirmOnly : _type,
        isWarmup: _warmup,
        repsText: _reps.text.trim(),
        repsMin: parseIntOrNull(_min.text),
        repsMax: parseIntOrNull(_max.text),
        restSec: parseIntOrNull(_rest.text) ?? 0,
        tip: _tip.text.trim(),
        fixedSets: parseIntOrNull(_fixed.text) ?? (_warmup ? 2 : null),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initial == null ? 'Novo exercício' : 'Editar exercício',
        ),
        actions: [TextButton(onPressed: _done, child: const Text('OK'))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Nome'),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: _warmup,
            title: const Text('Aquecimento'),
            subtitle: const Text('Só pede confirmação, séries fixas'),
            onChanged: (v) => setState(() => _warmup = v),
          ),
          if (!_warmup) ...[
            const SizedBox(height: 8),
            DropdownButtonFormField<LogType>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Tipo de registro'),
              items: [
                for (final t in LogType.values)
                  DropdownMenuItem(value: t, child: Text(t.label)),
              ],
              onChanged: (v) => setState(() => _type = v!),
            ),
          ],
          const SizedBox(height: 12),
          TextField(
            controller: _reps,
            decoration: const InputDecoration(
              labelText: 'Reps alvo (texto)',
              hintText: '6–8, 10/lado, 30–40 m',
            ),
            onChanged: _autoRange,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: NumberField(controller: _min, label: 'Reps mín.'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: NumberField(controller: _max, label: 'Reps máx.'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: NumberField(
                  controller: _rest,
                  label: 'Descanso',
                  suffix: 's',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: NumberField(
                  controller: _fixed,
                  label: 'Séries fixas',
                  hint: 'da semana',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _tip,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Dica técnica'),
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _done, child: const Text('Salvar exercício')),
        ],
      ),
    );
  }
}
