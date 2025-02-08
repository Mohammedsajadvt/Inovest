import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:inovest/core/app_settings/secure_storage.dart';
import 'package:inovest/core/common/api_constants.dart';
import 'package:inovest/data/models/category_model.dart';
import 'package:http/http.dart' as http;
import 'package:inovest/data/services/auth_service.dart';

class EntrepreneurService {
  final AuthService _authService = AuthService();

  // Create a new category
  Future<CategoryModel?> createCategory(String name, String description) async {
    final String url = "${ApiConstants.baseUrl}${ApiConstants.category}";
    final token = await SecureStorage().getToken();
    print("Token used for category creation: $token"); // Log token

    try {
      final response = await _makeRequest(
        url,
        "POST",
        body: jsonEncode({"name": name, "description": description}),
        token: token,
      );

      if (response != null && response.statusCode == 200) {
        print("Category created successfully: ${response.body}");
        return CategoryModel.fromJson(jsonDecode(response.body));
      } else {
        print('Error: ${response?.statusCode} - ${response?.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Get categories
  Future<List<CategoryModel>?> getCategory() async {
    final String url = "${ApiConstants.baseUrl}${ApiConstants.category}";
    final token = await SecureStorage().getToken();
    print("Token used for fetching categories: $token"); // Log token

    try {
      final response = await _makeRequest(url, "GET", token: token);
      if (response != null && response.statusCode == 200) {
        print("Response Body: ${response.body}"); // Log the response
        List<dynamic> data = jsonDecode(response.body)['data']; // Access 'data' field
        return data.map((category) => CategoryModel.fromJson(category)).toList();
      } else {
        print('Error: ${response?.statusCode} - ${response?.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Request handler with token refresh logic
  Future<http.Response?> _makeRequest(String url, String method,
      {String? body, String? token}) async {
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      http.Response response;

      if (method == "POST") {
        response = await http.post(Uri.parse(url), headers: headers, body: body);
      } else {
        response = await http.get(Uri.parse(url), headers: headers);
      }

      // Handle token expiry (401 response)
      if (response.statusCode == 401) {
        print("❌ Token expired, attempting to refresh...");
        final newAuth = await _authService.refreshToken();
        if (newAuth != null && newAuth.success) {
          // Fetch new token and retry the request
          token = await SecureStorage().getToken();
          print("🔄 Token refreshed successfully. Retrying the request...");

          if (method == "POST") {
            response = await http.post(Uri.parse(url), headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            }, body: body);
          } else {
            response = await http.get(Uri.parse(url), headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            });
          }
        } else {
          // Refresh token failed, clear stored tokens and prompt login
          await SecureStorage().clearTokenAndRole();
          print("Token refresh failed. Please log in again.");
          throw Exception("Session expired. Please log in again.");
        }
      }

      return response;
    } catch (e) {
      print("Request error: $e");
      throw Exception("Error making request: $e");
    }
  }
}
