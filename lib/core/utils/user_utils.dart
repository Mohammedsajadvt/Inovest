import 'package:inovest/core/app_settings/secure_storage.dart';

class UserUtils {
  static final SecureStorage _secureStorage = SecureStorage();

  static Future<String?> getCurrentUserId() async {
    return await _secureStorage.getUserId();
  }

  static Future<String?> getCurrentUserRole() async {
    return await _secureStorage.getRole();
  }

  static Future<String?> getToken() async {
    return await _secureStorage.getToken();
  }

  static Future<bool> isLoggedIn() async {
    final token = await _secureStorage.getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> saveUserData({
    required String token,
    required String role,
    required String userId,
  }) async {
    await _secureStorage.saveToken(token);
    await _secureStorage.saveRole(role);
    await _secureStorage.saveUserId(userId);
  }

  static Future<void> clearUserData() async {
    await _secureStorage.clearTokenAndRole();
  }
} 