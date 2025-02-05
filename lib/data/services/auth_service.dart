import 'dart:convert';

import 'package:inovest/core/common/api_constants.dart';
import 'package:inovest/data/models/login_model.dart';
import 'package:http/http.dart' as http;
import 'package:inovest/data/models/signup_model.dart';

class AuthService {
  Future<LoginModel?> loginUser(String email, String password) async {
    final String url = "${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return LoginModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      return LoginModel(success: false, message: "Something went wrong: $e");
    }
  }

  Future<SignUpModel?> signupUser(
      String name, String password, String email, String role) async {
    final String url = "${ApiConstants.baseUrl}${ApiConstants.signupEndpoint}";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {"name": name, "email": email, "password": password, "role": role}),
      );
      print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return SignUpModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      throw ("Signup Failed");
    }
  }
}
