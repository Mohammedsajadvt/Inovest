class ProfileModel {
  final bool success;
  final UserData data;

  ProfileModel({required this.success, required this.data});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      success: json['success'] ?? false,
      data: UserData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.toJson(),
    };
  }
}

class UserData {
  final String id;
  final String name;
  final String email;
  final String? passwordHash;
  final String? imageUrl;
  final String? fcmToken;
  final String? lastSeen;
  final String createdAt;
  final String updatedAt;
  final UserRole role;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    this.passwordHash,
    this.imageUrl,
    this.fcmToken,
    this.lastSeen,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      passwordHash: json['passwordHash'],
      imageUrl: json['imageUrl'],
      fcmToken: json['fcmToken'],
      lastSeen: json['lastSeen'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      role: UserRole.fromJson(json['role'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'passwordHash': passwordHash,
      'imageUrl': imageUrl,
      'fcmToken': fcmToken,
      'lastSeen': lastSeen,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'role': role.toJson(),
    };
  }
}

class UserRole {
  final String id;
  final String userId;
  final String currentRole;
  final String createdAt;
  final String updatedAt;

  UserRole({
    required this.id,
    required this.userId,
    required this.currentRole,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      currentRole: json['currentRole'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'currentRole': currentRole,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
