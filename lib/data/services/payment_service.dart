import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inovest/core/common/api_constants.dart';
import 'package:inovest/core/app_settings/secure_storage.dart';

class PaymentService {
  Future<Map<String, dynamic>> processPayment({
    required double amount,
    required String paymentMethod,
    required String projectId,
  }) async {
    final String url = "${ApiConstants.baseUrl}/payments/create";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${await SecureStorage().getToken()}"
        },
        body: jsonEncode({
          "projectId": projectId,
          "amount": amount,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return {
          "success": true,
          "message": "Payment initiated successfully",
          "data": responseData['data'],
        };
      } else {
        final responseBody = jsonDecode(response.body);
        return {
          "success": false,
          "message": responseBody['message'] ?? 'Payment processing failed',
        };
      }
    } catch (e) {
      print('Payment processing failed: $e');
      return {
        "success": false,
        "message": 'An error occurred while processing payment',
      };
    }
  }

  Future<Map<String, dynamic>> verifyPayment({
    required String paymentId,
    required String transactionId,
  }) async {
    final String url = "${ApiConstants.baseUrl}/payments/verify";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${await SecureStorage().getToken()}"
        },
        body: jsonEncode({
          "paymentId": paymentId,
          "transactionId": transactionId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          "success": true,
          "message": "Payment verified successfully",
          "data": responseData['data'],
        };
      } else {
        final responseBody = jsonDecode(response.body);
        return {
          "success": false,
          "message": responseBody['message'] ?? 'Payment verification failed',
        };
      }
    } catch (e) {
      print('Payment verification failed: $e');
      return {
        "success": false,
        "message": 'An error occurred while verifying payment',
      };
    }
  }
} 