class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.currency = 'DZD',
    this.avatarPath,
  });

  final int id;
  final String name;
  final String email;
  final String? phone;
  final String currency;
  final String? avatarPath;

  String get firstName => name.split(' ').first;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      currency: (json['currency'] as String?) ?? 'DZD',
      avatarPath: json['avatar_path'] as String?,
    );
  }
}
