import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/format.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/common.dart';
import '../../home/presentation/home_providers.dart';
import '../domain/block_generator.dart';
import '../domain/block_spec.dart';
import 'block_editor_screen.dart';

final blocksListProvider = FutureProvider.autoDispose<List<Block>>((ref) {
  ref.watch(dataVersionProvider);
  return ref.watch(blockRepositoryProvider).allBlocks();
});

class BlocksScreen extends ConsumerWidget {
  const BlocksScreen({super.key});

  Future<void> _openEditor(
    BuildContext context, {
    int? blockId,
    BlockSpec? spec,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlockEditorScreen(blockId: blockId, initial: spec),
      ),
    );
  }

  BlockSpec _emptySpec(int count) {
    final today = DateTime.now();
    final nextMonday = mondayOf(today.add(const Duration(days: 7)));
    return BlockSpec(
      name: 'Bloco ${count + 1}',
      startDate: nextMonday,
      weeks: 8,
      workouts: [WorkoutSpec(name: 'Força A')],
      schedule: {},
      weekSpecs: [],
    )..normalizeWeeks();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocks = ref.watch(blocksListProvider);
    final repo = ref.read(blockRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Blocos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            _openEditor(context, spec: _emptySpec(blocks.value?.length ?? 0)),
        icon: const Icon(Icons.add),
        label: const Text('Novo bloco'),
      ),
      body: blocks.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (list) {
          if (list.isEmpty) return const EmptyHint('Nenhum bloco cadastrado.');
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              for (final b in list)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  b.name,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                              if (b.isActive)
                                const Chip(
                                  label: Text('Ativo'),
                                  avatar: Icon(Icons.check, size: 18),
                                ),
                            ],
                          ),
                          Text(
                            '${b.weeks} semanas · início ${formatDate(b.startDate)}',
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              if (!b.isActive)
                                TextButton.icon(
                                  onPressed: () async {
                                    await repo.setActive(b.id);
                                    ref
                                        .read(dataVersionProvider.notifier)
                                        .bump();
                                  },
                                  icon: const Icon(Icons.play_circle),
                                  label: const Text('Ativar'),
                                ),
                              TextButton.icon(
                                onPressed: () async {
                                  final spec = await repo.loadSpec(b.id);
                                  if (context.mounted) {
                                    await _openEditor(
                                      context,
                                      blockId: b.id,
                                      spec: spec,
                                    );
                                  }
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text('Editar'),
                              ),
                              TextButton.icon(
                                onPressed: () async {
                                  final ok = await confirmDialog(
                                    context,
                                    title: 'Duplicar ${b.name}?',
                                    message: 'Cria uma cópia começando logo depois do fim deste bloco. Você pode editar em seguida.',
                                    confirm: 'Duplicar',
                                  );
                                  if (!ok) return;
                                  final id = await repo.duplicate(b.id);
                                  ref.read(dataVersionProvider.notifier).bump();
                                  final spec = await repo.loadSpec(id);
                                  if (context.mounted) {
                                    await _openEditor(
                                      context,
                                      blockId: id,
                                      spec: spec,
                                    );
                                  }
                                },
                                icon: const Icon(Icons.copy),
                                label: const Text('Duplicar'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
