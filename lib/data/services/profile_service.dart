import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inovest/core/app_settings/secure_storage.dart';
import 'package:inovest/core/common/api_constants.dart';
import 'package:inovest/data/models/profile_model.dart';
import 'package:inovest/data/services/auth_service.dart';
import 'package:inovest/core/app_settings/unauthorized_notifier.dart';

class ProfileService {
  final AuthService _authService = AuthService();

  Map<String, String> _buildHeaders(String? token) {
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  Future<void> _handleUnauthorized() async {
    await SecureStorage().clearTokenAndRole();
    UnauthorizedNotifier().notifyUnauthorized();
  }

  Future<http.Response?> _makeRequest(String url, String method,
      {String? body, String? token}) async {
    final headers = _buildHeaders(token);

    try {
      http.Response response;

      if (method == "POST") {
        response = await http.post(Uri.parse(url), headers: headers, body: body);
      } else if (method == "PUT") {
        response = await http.put(Uri.parse(url), headers: headers, body: body);
      } else {
        response = await http.get(Uri.parse(url), headers: headers);
      }

      if (response.statusCode == 401) {
        print("Token expired, attempting to refresh...");
        final newAuth = await _authService.refreshToken();
        if (newAuth != null && newAuth.success) {
          token = await SecureStorage().getToken();
          print("Token refreshed successfully. Retrying the request...");
          final refreshedHeaders = _buildHeaders(token);

          if (method == "POST") {
            response = await http.post(Uri.parse(url), headers: refreshedHeaders, body: body);
          } else if (method == "PUT") {
            response = await http.put(Uri.parse(url), headers: refreshedHeaders, body: body);
          } else {
            response = await http.get(Uri.parse(url), headers: refreshedHeaders);
          }

          if (response.statusCode == 401) {
            await _handleUnauthorized();
            throw UnauthorizedException();
          }
        } else {
          await _handleUnauthorized();
          throw UnauthorizedException();
        }
      }

      return response;
    } catch (e) {
      if (e is UnauthorizedException) {
        rethrow;
      }
      print("Request error: $e");
      throw Exception("Error making request: $e");
    }
  }

  Future<ProfileModel?> getProfile() async {
    final String url = "${ApiConstants.baseUrl}${ApiConstants.profile}";
    final token = await SecureStorage().getToken();

    try {
      final response = await _makeRequest(url, "GET", token: token);
      if (response != null && response.statusCode == 200) {
        return ProfileModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error: ${response?.statusCode} - ${response?.body}');
      }
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }

  Future<ProfileModel?> updateProfile(ProfileModel profile) async {
    final String url = "${ApiConstants.baseUrl}${ApiConstants.profile}";
    final token = await SecureStorage().getToken();
    final String body = jsonEncode(profile.toJson());

    try {
      final response = await _makeRequest(url, "PUT", body: body, token: token);
      if (response != null && response.statusCode == 200) {
        return ProfileModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error: ${response?.statusCode} - ${response?.body}');
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
