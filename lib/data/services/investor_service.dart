import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inovest/core/app_settings/secure_storage.dart';
import 'package:inovest/core/common/api_constants.dart';
import 'package:inovest/data/models/categories_ideas.dart';
import 'package:inovest/data/models/investor_categories.dart';
import 'package:inovest/data/models/top_ideas_model.dart';
import 'package:inovest/data/services/auth_service.dart';

class InvestorService {
  final AuthService _authService = AuthService();

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

      if (response.statusCode == 401) {
        print("Token expired, attempting to refresh...");
        final newAuth = await _authService.refreshToken();
        if (newAuth != null && newAuth.success) {
          token = await SecureStorage().getToken();
          print("Token refreshed successfully. Retrying the request...");

          final refreshedHeaders = {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          };

          if (method == "POST") {
            response = await http.post(Uri.parse(url),
                headers: refreshedHeaders, body: body);
          } else {
            response = await http.get(Uri.parse(url), headers: refreshedHeaders);
          }
        } else {
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

  Future<TopIdeas?> topIdeas() async {
    final url = "${ApiConstants.baseUrl}${ApiConstants.topIdeas}";
    final token = await SecureStorage().getToken();
    try {
      final response = await _makeRequest(url, "GET", token: token);
      if (response != null && response.statusCode == 200) {
        return TopIdeas.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error: ${response?.statusCode} - ${response?.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch top ideas: $e');
    }
  }

  Future<InvestorCategories?> investorCategories() async {
    final url = "${ApiConstants.baseUrl}${ApiConstants.investorCategories}";
    final token = await SecureStorage().getToken();
    try {
      final response = await _makeRequest(url, "GET", token: token);
      if (response != null && response.statusCode == 200) {
        return InvestorCategories.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error: ${response?.statusCode} - ${response?.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch investor categories: $e');
    }
  }
   Future<CategoriesIdeas?> ideas(id) async {
    final url = "${ApiConstants.baseUrl}/investor/categories/$id/ideas";
    final token = await SecureStorage().getToken();
    try {
      final response = await _makeRequest(url, "GET", token: token);
      if (response != null && response.statusCode == 200) {
        return CategoriesIdeas.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error: ${response?.statusCode} - ${response?.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch investor categories: $e');
    }
  }
}
