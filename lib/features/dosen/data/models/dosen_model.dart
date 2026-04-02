class DosenModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final String city;

  DosenModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.city,
  });

  factory DosenModel.fromJson(Map<String, dynamic> json) {
    return DosenModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      city: json['address']?['city'] ?? '',
    );
  }
}