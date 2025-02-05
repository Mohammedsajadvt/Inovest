import 'dart:convert';

class SignUpModel {
  final bool success;
  final String name;
  final String email;
  final String password;
  final String role;
  final String message;

  SignUpModel({
    required this.success,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.message
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) => SignUpModel(
        success: json["success"] ?? false,
        name: json["name"],
        email: json["email"],
        password: json["password"],
        role: json["role"],
        message: json["message"],
      );
}
