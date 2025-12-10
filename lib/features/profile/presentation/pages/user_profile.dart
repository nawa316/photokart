const String kDefaultAvatarPath = 'assets/images/profile.jpg';

class UserProfile {
  String name;
  String email;
  String phone;
  String password;

  /// Bisa:
  /// - path asset: "assets/images/profile.png"
  /// - path file lokal (Android/iOS)
  /// - blob url (web)
  String avatarPath;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    String? avatarPath,
  }) : avatarPath =
            (avatarPath == null || avatarPath.isEmpty) ? kDefaultAvatarPath : avatarPath;

  /// Map untuk update ke Supabase (tabel users)
  Map<String, dynamic> toUpdateMap() {
    return {
      'username': name,        // kolom username
      'email': email,          // kolom email
      'phone': phone,          // kolom phone
      'avatarUrl': avatarPath, // kolom avatarUrl
      // role di-handle terpisah di profile_page (Switch Role)
    };
  }

  /// Baca dari row Supabase (tabel users)
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['username'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      // password tidak disimpan di tabel users, jadi pakai masking saja
      password: '**************************',
      avatarPath: map['avatarUrl'] as String? ?? kDefaultAvatarPath,
    );
  }

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? avatarPath,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}
