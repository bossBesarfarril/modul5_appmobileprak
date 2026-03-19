import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_modul3/core/widgets/common_widgets.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_avatar_widget.dart';
import '../widgets/profile_info_card_widget.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.read(profileNotifierProvider.notifier).refresh(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: profileState.when(
        loading: () => const LoadingWidget(),
        error: (error, stack) => CustomErrorWidget(
          message: 'Gagal memuat profil: ${error.toString()}',
          onRetry: () => ref.read(profileNotifierProvider.notifier).refresh(),
        ),
        data: (profile) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              ProfileAvatar(nama: profile.nama, role: profile.role),
              const SizedBox(height: 32),
              ProfileInfoCard(
                icon: Icons.email_outlined,
                label: 'Email',
                value: profile.email,
              ),
              const SizedBox(height: 12),
              ProfileInfoCard(
                icon: Icons.phone_outlined,
                label: 'Telepon',
                value: profile.telepon,
              ),
              const SizedBox(height: 12),
              ProfileInfoCard(
                icon: Icons.school_outlined,
                label: 'Jurusan',
                value: profile.jurusan,
              ),
              const SizedBox(height: 12),
              ProfileInfoCard(
                icon: Icons.location_on_outlined,
                label: 'Kampus',
                value: profile.kampus,
              ),
            ],
          ),
        ),
      ),
    );
  }
}