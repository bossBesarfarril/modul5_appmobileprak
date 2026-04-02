import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/dosen_model.dart';
import '../providers/dosen_provider.dart';

class DosenPage extends ConsumerWidget {
  const DosenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dosenState = ref.watch(dosenNotifierProvider);
    final savedUsers = ref.watch(savedUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Dosen'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(dosenNotifierProvider),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SavedUserSection(savedUsers: savedUsers, ref: ref),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              'Daftar Dosen',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: dosenState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
              ),
              data: (dosenList) => DosenListWithSave(
                dosenList: dosenList,
                onRefresh: () async => ref.invalidate(dosenNotifierProvider),
                ref: ref,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGETS ---

class SavedUserSection extends ConsumerWidget {
  final AsyncValue<List<Map<String, String>>> savedUsers;
  final WidgetRef ref;

  const SavedUserSection({Key? key, required this.savedUsers, required this.ref}) : super(key: key);

  String _formatDate(String isoString) {
    if (isoString.isEmpty) return '-';
    try {
      final date = DateTime.parse(isoString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
    } catch (e) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.storage_rounded, size: 16),
              const SizedBox(width: 6),
              const Text('Data Tersimpan di Local Storage',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const Spacer(),
              savedUsers.maybeWhen(
                data: (users) => users.isNotEmpty
                    ? TextButton.icon(
                        onPressed: () async {
                          await ref.read(dosenNotifierProvider.notifier).clearSavedUsers();
                          ref.invalidate(savedUsersProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Semua data tersimpan dihapus')));
                          }
                        },
                        icon: const Icon(Icons.delete_sweep_outlined, size: 14, color: Colors.red),
                        label: const Text('Hapus Semua', style: TextStyle(fontSize: 12, color: Colors.red)),
                      )
                    : const SizedBox.shrink(),
                orElse: () => const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          savedUsers.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, s) => const Text('Gagal membaca data', style: TextStyle(color: Colors.red)),
            data: (users) {
              if (users.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Colors.grey.shade400),
                      const SizedBox(width: 8),
                      Text('Belum ada data. Tap ikon save untuk menyimpan.',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    ],
                  ),
                );
              }
              return Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  separatorBuilder: (_, __) => Divider(height: 1, color: Colors.green.shade100),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.green.shade100,
                        child: Text('${index + 1}',
                            style: TextStyle(fontSize: 11, color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                      ),
                      title: Text(user['username'] ?? '-'),
                      subtitle: Text('ID: ${user['user_id']} • ${_formatDate(user['saved_at'] ?? '')}',
                          style: const TextStyle(fontSize: 11)),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, size: 16, color: Colors.red),
                        onPressed: () async {
                          await ref.read(dosenNotifierProvider.notifier).removeSavedUser(user['user_id'] ?? '');
                          ref.invalidate(savedUsersProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${user['username']} dihapus')));
                          }
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DosenListWithSave extends StatelessWidget {
  final List<DosenModel> dosenList;
  final Future<void> Function() onRefresh;
  final WidgetRef ref;

  const DosenListWithSave({Key? key, required this.dosenList, required this.onRefresh, required this.ref}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: dosenList.length,
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        itemBuilder: (context, index) {
          final dosen = dosenList[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(child: Text('${dosen.id}')),
              title: Text(dosen.name),
              subtitle: Text('${dosen.username} • ${dosen.email}\n${dosen.city}'),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.save, size: 18),
                tooltip: 'Simpan user ini',
                onPressed: () async {
                  await ref.read(dosenNotifierProvider.notifier).saveSelectedDosen(dosen);
                  ref.invalidate(savedUsersProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${dosen.username} berhasil disimpan ke local storage')));
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}