import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inovest/core/app_settings/secure_storage.dart';
import 'package:inovest/core/common/api_constants.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:inovest/core/utils/index.dart';
import 'package:inovest/data/models/auth_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

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

  Future<AuthModel?> googleLogin(
      {required String email, required String name, required String googleId}) async {
    final String url = "${ApiConstants.baseUrl}${ApiConstants.googleLogin}";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "name": name,
          "googleId": googleId,
        }),
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
      print('Google login failed: $e');
      return AuthModel(success: false, message: 'An error occurred: $e');
    }
  }

  Future<AuthModel?> forgotPassword(String email) async {
    final String url = "${ApiConstants.baseUrl}${ApiConstants.forgotPassword}";

    String platform;
    Map<String, dynamic> requestBody = {"email": email};

    if (kIsWeb) {
      platform = "web";
      requestBody["clientUrl"] = ApiConstants.webClientUrl;
    } else if (Platform.isIOS) {
      platform = "ios";
    } else {
      platform = "android";
    }

    requestBody["platform"] = platform;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return AuthModel(
          success: true,
          message: responseBody['message'] ?? 'Reset instructions sent to your email',
        );
      } else {
        final responseBody = jsonDecode(response.body);
        return AuthModel(
          success: false,
          message: responseBody['message'] ?? 'Failed to process request',
        );
      }
    } catch (e) {
      print('Forgot password failed: $e');
      return AuthModel(success: false, message: 'An error occurred: $e');
    }
  }

  Future<AuthModel?> resetPassword(String token, String newPassword) async {
    final String url = "${ApiConstants.baseUrl}${ApiConstants.resetPassword}";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "token": token,
          "password": newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return AuthModel(
          success: true,
          message: responseBody['message'] ?? 'Password reset successful',
        );
      } else {
        final responseBody = jsonDecode(response.body);
        return AuthModel(
          success: false,
          message: responseBody['message'] ?? 'Failed to reset password',
        );
      }
    } catch (e) {
      print('Reset password failed: $e');
      return AuthModel(success: false, message: 'An error occurred: $e');
    }
  }

  Future<AuthModel?> switchRole(String userId, String newRole) async {
    final String url = "${ApiConstants.baseUrl}/profile/role";

    try {
      String? token = await SecureStorage().getToken();
      if (token == null || token.isEmpty) {
        return AuthModel(success: false, message: 'Not xwauthenticated');
      }

      print('Switching role to: $newRole');
      print('API URL: $url');

      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({"role": newRole}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final jsonData = jsonDecode(response.body);
          if (jsonData['success']) {
            await SecureStorage().saveRole(newRole);
            
            return AuthModel(
              success: true,
              message: jsonData['message'] ?? "Role switched successfully",
              data: AuthData(
                tokens: Tokens(accessToken: token, refreshToken: ""),
                user: User(
                  id: userId,
                  name: "",
                  email: "",
                  imageUrl: "",
                  role: newRole,
                ),
              ),
            );
          }
          return AuthModel(
            success: false,
            message: jsonData['message'] ?? 'Role switch failed',
          );
        } catch (e) {
          print('JSON parsing error: $e');
          return AuthModel(
            success: false,
            message: 'Invalid response format',
          );
        }
      } else if (response.statusCode == 401) {
        await SecureStorage().clearTokenAndRole();
        return AuthModel(
          success: false,
          message: 'Session expired. Please login again.',
        );
      } else {
        try {
          final responseBody = jsonDecode(response.body);
          return AuthModel(
            success: false,
            message: responseBody['message'] ?? 'Role switch failed',
          );
        } catch (e) {
          return AuthModel(
            success: false,
            message: 'Server error: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      print('Role switch failed: $e');
      return AuthModel(success: false, message: 'Network error occurred');
    }
  }
}
