class ProfileModel {
  final String nama;
  final String role;
  final String email;
  final String telepon;
  final String jurusan;
  final String kampus;

  ProfileModel({
    required this.nama,
    required this.role,
    required this.email,
    required this.telepon,
    required this.jurusan,
    required this.kampus,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      nama: json['nama'] ?? '',
      role: json['role'] ?? '',
      email: json['email'] ?? '',
      telepon: json['telepon'] ?? '',
      jurusan: json['jurusan'] ?? '',
      kampus: json['kampus'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'role': role,
      'email': email,
      'telepon': telepon,
      'jurusan': jurusan,
      'kampus': kampus,
    };
  }

  ProfileModel copyWith({
    String? nama,
    String? role,
    String? email,
    String? telepon,
    String? jurusan,
    String? kampus,
  }) {
    return ProfileModel(
      nama: nama ?? this.nama,
      role: role ?? this.role,
      email: email ?? this.email,
      telepon: telepon ?? this.telepon,
      jurusan: jurusan ?? this.jurusan,
      kampus: kampus ?? this.kampus,
    );
  }
}