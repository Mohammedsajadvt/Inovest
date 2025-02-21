import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inovest/core/app_settings/secure_storage.dart';
import 'package:inovest/core/common/api_constants.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:inovest/core/utils/index.dart';
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
        final responseBody = jsonDecode(response.body);
        return AuthModel(
          success: responseBody['success'] ?? false,
          message: responseBody['message'] ?? 'Unknown error',
        );
      }
    } catch (e) {
      print('Login failed: $e');
      return AuthModel(success: false, message: 'An error occurred: $e');
    }
  }

  Future<AuthModel?> signupUser(
      String name, String password, String email, String role) async {
    final String url = "${ApiConstants.baseUrl}${ApiConstants.signupEndpoint}";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {"name": name, "email": email, "password": password, "role": role}),
      );

      if (response.statusCode == 201) {
        return AuthModel.fromJson(jsonDecode(response.body));
      } else {
        final responseBody = jsonDecode(response.body);
        return AuthModel(
          success: responseBody['success'] ?? false,
          message: responseBody['message'] ?? 'Unknown error',
        );
      }
    } catch (e) {
      print('Signup failed: $e');
      return AuthModel(success: false, message: 'An error occurred: $e');
    }
  }

  Future<AuthModel?> refreshToken() async {
    final String url = "${ApiConstants.baseUrl}${ApiConstants.refreshToken}";

    try {
      String? refreshToken = await SecureStorage().getToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        SnackBar(
            backgroundColor: Colors.white,
            content: Text(
              'Session Expired Please log in again.',
              style: TextStyle(color: AppArray().colors[1]),
            ));
        
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refreshToken": refreshToken}),
      );

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
        print("❌ Refresh token request failed.");
        return null;
      }
    } catch (e) {
      print("❌ Refresh token request error: $e");
      return null;
    }
  }
}
