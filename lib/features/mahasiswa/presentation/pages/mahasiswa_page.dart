import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/mahasiswa_model.dart';
import '../providers/mahasiswa_provider.dart';

class MahasiswaPage extends ConsumerWidget {
  const MahasiswaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mahasiswaState = ref.watch(mahasiswaNotifierProvider);
    final savedMahasiswa = ref.watch(savedMahasiswaProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Mahasiswa'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(mahasiswaNotifierProvider),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SavedMahasiswaSection(savedMahasiswa: savedMahasiswa, ref: ref),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              'Daftar Mahasiswa',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: mahasiswaState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (list) => RefreshIndicator(
                onRefresh: () async => ref.invalidate(mahasiswaNotifierProvider),
                child: ListView.builder(
                  itemCount: list.length,
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    final mhs = list[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Text('${mhs.id}')),
                        title: Text(mhs.name),
                        subtitle: Text('${mhs.username} • ${mhs.email}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.save, color: Colors.blue),
                          onPressed: () async {
                            await ref.read(mahasiswaNotifierProvider.notifier).saveSelectedMahasiswa(mhs);
                            ref.invalidate(savedMahasiswaProvider);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${mhs.username} tersimpan ke local!')));
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SavedMahasiswaSection extends ConsumerWidget {
  final AsyncValue<List<Map<String, String>>> savedMahasiswa;
  final WidgetRef ref;

  const SavedMahasiswaSection({Key? key, required this.savedMahasiswa, required this.ref}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Mahasiswa Tersimpan (Offline)', style: TextStyle(fontWeight: FontWeight.bold)),
              TextButton.icon(
                onPressed: () async {
                  await ref.read(mahasiswaNotifierProvider.notifier).clearSavedMahasiswa();
                  ref.invalidate(savedMahasiswaProvider);
                },
                icon: const Icon(Icons.delete, size: 14, color: Colors.red),
                label: const Text('Clear All', style: TextStyle(color: Colors.red, fontSize: 12)),
              )
            ],
          ),
          savedMahasiswa.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const Text('Error load data'),
            data: (users) {
              if (users.isEmpty) return const Text('Belum ada data mahasiswa tersimpan.', style: TextStyle(color: Colors.grey));
              return Container(
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      dense: true,
                      title: Text(user['username'] ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, size: 16, color: Colors.red),
                        onPressed: () async {
                          await ref.read(mahasiswaNotifierProvider.notifier).removeSavedMahasiswa(user['user_id'] ?? '');
                          ref.invalidate(savedMahasiswaProvider);
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