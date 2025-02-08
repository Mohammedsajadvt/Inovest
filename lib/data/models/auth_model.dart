class AuthModel {
  final bool success;
  final String message;
  final AuthData? data;

  AuthModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? AuthData.fromJson(json['data']) : null,
    );
  }
}

class AuthData {
  final Tokens tokens;
  final User user;

  AuthData({
    required this.tokens,
    required this.user,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      tokens: Tokens.fromJson(json['tokens']),
      user: User.fromJson(json['user']),
    );
  }
}



class Tokens {
  final String accessToken;
  final String refreshToken;

  Tokens({required this.accessToken, required this.refreshToken});

  factory Tokens.fromJson(Map<String, dynamic> json) {
    return Tokens(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String imageUrl;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      imageUrl: json['imageUrl'],
      role: json['role'],
    );
  }
}
