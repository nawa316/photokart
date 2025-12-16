class UserModel {
  final String id;
  final String username;
  final String email;
  final String? phone;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.phone,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'created_at': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? phone,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
