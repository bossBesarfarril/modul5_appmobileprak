import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/dosen_model.dart';
import '../../data/repositories/dosen_repository.dart';

final dosenRepositoryProvider = Provider<DosenRepository>((ref) {
  return DosenRepository();
});

class DosenNotifier extends StateNotifier<AsyncValue<List<DosenModel>>> {
  final DosenRepository _repository;

  DosenNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadDosenList();
  }

  Future<void> loadDosenList() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getDosenList();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await loadDosenList();
  }
}

final dosenNotifierProvider = StateNotifierProvider.autoDispose<
    DosenNotifier, AsyncValue<List<DosenModel>>>(
  (ref) {
    final repository = ref.watch(dosenRepositoryProvider);
    return DosenNotifier(repository);
  },
);
