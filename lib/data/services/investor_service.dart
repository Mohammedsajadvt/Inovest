import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inovest/core/common/api_constants.dart';
import 'package:inovest/data/models/categories_ideas.dart';
import 'package:inovest/data/models/investor_categories.dart';
import 'package:inovest/data/models/top_ideas_model.dart';
import 'package:inovest/data/services/auth_service.dart';
import 'package:inovest/core/app_settings/unauthorized_notifier.dart';
import 'package:dio/dio.dart';
import 'package:inovest/core/utils/api_helper.dart';
import 'package:inovest/core/utils/user_utils.dart';

class InvestorService {
  final AuthService _authService = AuthService();
  final ApiHelper _apiHelper = ApiHelper();

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
          token = await UserUtils.getToken();
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

  Future<void> _handleUnauthorized() async {
    await UserUtils.clearUserData();
    UnauthorizedNotifier().notifyUnauthorized();
  }

  Future<TopIdeas?> topIdeas() async {
    final url = "${ApiConstants.baseUrl}${ApiConstants.topIdeas}";
    final token = await UserUtils.getToken();
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
    final token = await UserUtils.getToken();
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

  Future<CategoriesIdeasModel?> ideas(id) async {
    final url = "${ApiConstants.baseUrl}/investor/categories/$id/ideas";
    final token = await UserUtils.getToken();
    try {
      final response = await _makeRequest(url, "GET", token: token);
      if (response != null && response.statusCode == 200) {
        return CategoriesIdeasModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error: ${response?.statusCode} - ${response?.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch investor categories: $e');
    }
  }

  Future<TopIdeas?> searchIdeas(String query) async {
    final url = "${ApiConstants.baseUrl}${ApiConstants.topIdeas}/search?query=$query";
    final token = await UserUtils.getToken();
    try {
      final response = await _makeRequest(url, "GET", token: token);
      if (response != null && response.statusCode == 200) {
        return TopIdeas.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error: ${response?.statusCode} - ${response?.body}');
      }
    } catch (e) {
      throw Exception('Failed to search ideas: $e');
    }
  }

  Future<Map<String, dynamic>> getIdeaDetails(String ideaId) async {
    try {
      final response = await _apiHelper.get('/investor/ideas/$ideaId');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> rateIdea(
    String ideaId,
    int rating,
    String comment,
  ) async {
    try {
      final response = await _apiHelper.post(
        '/investor/ideas/$ideaId/rate',
        data: {
          'rating': rating,
          'comment': comment,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> showInterest(String ideaId) async {
    try {
      final response = await _apiHelper.post('/investor/ideas/$ideaId/interest');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getInterests() async {
    try {
      final response = await _apiHelper.get('/investor/interests');
      return List<Map<String, dynamic>>.from(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }
}
