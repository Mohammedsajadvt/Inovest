class LoginModel {
  final bool success;
  final String? accessToken;
  final String? refreshToken;
  final String? message;
  final String? role; 

  LoginModel({
    required this.success,
    this.accessToken,
    this.refreshToken,
    this.message,
    this.role
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      success: json['success'] ?? false,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      message: json['message'] as String?,
      role: json['role'] as String?,
    );
  }
}
