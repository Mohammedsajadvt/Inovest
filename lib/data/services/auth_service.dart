import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inovest/core/app_settings/secure_storage.dart';
import 'package:inovest/core/common/api_constants.dart';
import 'package:inovest/data/models/auth_model.dart';

class AuthService {
  Future<AuthModel?> loginUser(String email, String password) async {
    final String url = "${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        return AuthModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print('Login failed: $e');
      return null;
    }
  }

  Future<AuthModel?> signupUser(
      String name, String password, String email, String role) async {
    final String url = "${ApiConstants.baseUrl}${ApiConstants.signupEndpoint}";

    try {
      print("Sending sign-up request to $url");
      print("Request Body: ${jsonEncode({
            "name": name,
            "email": email,
            "password": password,
            "role": role
          })}");

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {"name": name, "email": email, "password": password, "role": role}),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 201) {
        return AuthModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            "Failed to sign up. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print('Signup failed: $e');
      throw Exception("Error during sign up: $e");
    }
  }
  Future<AuthModel?> refreshToken() async {
  final String url = "${ApiConstants.baseUrl}${ApiConstants.refreshToken}";

  try {
    String? refreshToken = await SecureStorage().getToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      print("❌ No refresh token available.");
      return null;
    }

    print("🔄 Sending refresh token request...");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"refreshToken": refreshToken}),
    );

    print("🟢 Refresh Token Response Status Code: ${response.statusCode}");
    print("🟢 Refresh Token Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData.containsKey('tokens')) {
        await SecureStorage().saveToken(jsonData['tokens']['accessToken']);
        return AuthModel.fromJson(jsonData);
      } else {
        print("❌ No tokens received from refresh-token API.");
        return null;
      }
    } else {
      print("❌ Refresh token request failed: Status Code ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("❌ Refresh token request error: $e");
    return null;
  }
}

}
