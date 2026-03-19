import '../models/profile_model.dart';

class ProfileRepository {
  Future<ProfileModel> getProfile() async {
    await Future.delayed(const Duration(seconds: 1));
    return ProfileModel(
      nama: 'Admin D4TI',
      role: 'Administrator',
      email: 'admin@d4ti.ac.id',
      telepon: '+62 812 3456 7890',
      jurusan: 'D4 Teknik Informatika',
      kampus: 'Politeknik Negeri',
    );
  }

  Future<ProfileModel> refreshProfile() async {
    return getProfile();
  }
}