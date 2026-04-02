import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_modul3/core/services/local_storage_service.dart';
import '../../data/models/dosen_model.dart';
import '../../data/repositories/dosen_repository.dart';

final dosenRepositoryProvider = Provider<DosenRepository>((ref) => DosenRepository());
final localStorageServiceProvider = Provider<LocalStorageService>((ref) => LocalStorageService());

// Provider untuk data tersimpan
final savedUsersProvider = FutureProvider<List<Map<String, String>>>((ref) async {
  final storage = ref.watch(localStorageServiceProvider);
  return storage.getSavedDosen();
});

class DosenNotifier extends StateNotifier<AsyncValue<List<DosenModel>>> {
  final DosenRepository _repository;
  final LocalStorageService _storage;

  DosenNotifier(this._repository, this._storage) : super(const AsyncValue.loading()) {
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

  Future<void> saveSelectedDosen(DosenModel dosen) async {
    await _storage.addDosenToSavedList(
      userId: dosen.id.toString(),
      username: dosen.username,
    );
  }

  Future<void> removeSavedUser(String userId) async {
    await _storage.removeSavedDosen(userId);
  }

  Future<void> clearSavedUsers() async {
    await _storage.clearSavedDosen();
  }
}

final dosenNotifierProvider = StateNotifierProvider.autoDispose<DosenNotifier, AsyncValue<List<DosenModel>>>((ref) {
  final repository = ref.watch(dosenRepositoryProvider);
  final storage = ref.watch(localStorageServiceProvider);
  return DosenNotifier(repository, storage);
});