import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/providers.dart';
import '../../blocks/data/block_repository.dart';

/// Incrementado sempre que blocos/registros mudam, para recarregar telas.
class DataVersion extends Notifier<int> {
  @override
  int build() => 0;
  void bump() => state++;
}

final dataVersionProvider = NotifierProvider<DataVersion, int>(DataVersion.new);

final todayPlanProvider = FutureProvider.autoDispose<DayPlan?>((ref) {
  ref.watch(dataVersionProvider);
  final now = ref.watch(clockProvider)();
  return ref.watch(blockRepositoryProvider).dayPlan(now);
});

final activeTemplatesProvider =
    FutureProvider.autoDispose<List<WorkoutTemplate>>((ref) async {
      ref.watch(dataVersionProvider);
      final repo = ref.watch(blockRepositoryProvider);
      final block = await repo.activeBlock();
      if (block == null) return [];
      return repo.templatesOf(block.id);
    });
