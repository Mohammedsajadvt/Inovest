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
  final String fullName;
  final String email;
  final String? passwordHash;
  final String? imageUrl;
  final String? fcmToken;
  final String? lastSeen;
  final String createdAt;
  final String updatedAt;
  final UserRole role;
  final String? phoneNumber;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.fullName,
    this.passwordHash,
    this.imageUrl,
    this.fcmToken,
    this.lastSeen,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.phoneNumber,
  });

  UserData copyWith({
    String? id,
    String? name,
    String? fullName,
    String? email,
    String? passwordHash,
    String? imageUrl,
    String? fcmToken,
    String? lastSeen,
    String? createdAt,
    String? updatedAt,
    UserRole? role,
    String? phoneNumber,
  }) {
    return UserData(
      id: id ?? this.id,
      name: name ?? this.name,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      imageUrl: imageUrl ?? this.imageUrl,
      fcmToken: fcmToken ?? this.fcmToken,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      fullName: json['fullName'] ?? 'N/A',
      email: json['email'] ?? '',
      passwordHash: json['passwordHash'],
      imageUrl: json['imageUrl'],
      fcmToken: json['fcmToken'],
      lastSeen: json['lastSeen'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      role: UserRole.fromJson(json['role'] ?? {}),
      phoneNumber: json['phoneNumber'] ?? "N/A",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fullName': fullName,
      'email': email,
      'passwordHash': passwordHash,
      'imageUrl': imageUrl,
      'fcmToken': fcmToken,
      'lastSeen': lastSeen,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'role': role.toJson(),
      'phoneNumber': phoneNumber,
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
