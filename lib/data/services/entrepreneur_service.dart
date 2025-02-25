import 'dart:convert';
import 'package:inovest/core/app_settings/secure_storage.dart';
import 'package:inovest/core/common/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:inovest/data/models/category_model.dart';
import 'package:inovest/data/models/ideas_model.dart';
import 'package:inovest/data/services/auth_service.dart';
import 'package:inovest/data/models/entrepreneur_ideas_model.dart';
import 'package:inovest/core/app_settings/unauthorized_notifier.dart';

class EntrepreneurService {
  final AuthService _authService = AuthService();

  Future<void> _handleUnauthorized() async {
    await SecureStorage().clearTokenAndRole();
    UnauthorizedNotifier().notifyUnauthorized();
  }

  Future<IdeasModel?> createIdeas(String title, String abstract,
      double expectedInvestment, String categoryId) async {
    final String url = "${ApiConstants.baseUrl}${ApiConstants.entrepreneurIdeas}";
    final token = await SecureStorage().getToken();
    try {
      final response = await _makeRequest(
        url,
        "POST",
        body: jsonEncode({
          "title": title,
          "abstract": abstract,
          "expectedInvestment": expectedInvestment,
          "categoryId": categoryId
        }),
        token: token,
      );

      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        print("Ideas created successfully: ${response.body}");
        return IdeasModel.fromJson(jsonDecode(response.body));
      } else {
      throw Exception('Error: ${response?.statusCode} - ${response?.body}');
      }
    } catch (e) {
    throw Exception('Failed to create ideas: $e');
    }
  }

  Future<IdeasModel?> getIdeas() async {
    final String url = "${ApiConstants.baseUrl}${ApiConstants.entrepreneurIdeas}";
    final token = await SecureStorage().getToken();
    try {
      final response = await _makeRequest(url, "GET", token: token);
      if (response != null && response.statusCode == 200) {
        return IdeasModel.fromJson(jsonDecode(response.body));
      } else {
      throw Exception('Error: ${response?.statusCode} - ${response?.body}');
      }
    } catch (e) {
    throw Exception('Failed to load ideas: $e');
    }
  }

   Future<List<CategoryModel>?> getCategory() async {
    final String url = "${ApiConstants.baseUrl}${ApiConstants.category}";
    final token = await SecureStorage().getToken();
   print('Token here: $token end');
    try {
      final response = await _makeRequest(url, "GET", token: token);
      if (response != null && response.statusCode == 200) {
        print("Response Body: ${response.body}"); 
        List<dynamic> data = jsonDecode(response.body)['data']; 
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

  Future<EntrepreneurIdeasModel?> getEntrepreneurIdeas() async {
    final String url = "${ApiConstants.baseUrl}${ApiConstants.entrepreneurIdeas}";
    final token = await SecureStorage().getToken();

    try {
      final response = await _makeRequest(url, "GET", token: token);
      
      if (response != null && response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return EntrepreneurIdeasModel.fromJson({
          'success': true,
          'data': responseData['data'],
        });
      } else {
        print('Failed to load ideas: ${response?.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error loading ideas: $e');
      return null;
    }
  }

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
}
