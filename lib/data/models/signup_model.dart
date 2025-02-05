import 'package:meta/meta.dart';
import 'dart:convert';

class SignUpModel {
    final String name;
    final String email;
    final String password;
    final String role;

    SignUpModel({
        required this.name,
        required this.email,
        required this.password,
        required this.role,
    });

    SignUpModel copyWith({
        String? name,
        String? email,
        String? password,
        String? role,
    }) => 
        SignUpModel(
            name: name ?? this.name,
            email: email ?? this.email,
            password: password ?? this.password,
            role: role ?? this.role,
        );

    factory SignUpModel.fromRawJson(String str) => SignUpModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SignUpModel.fromJson(Map<String, dynamic> json) => SignUpModel(
        name: json["name"],
        email: json["email"],
        password: json["password"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "role": role,
    };
}
