import 'package:flutter/material.dart';
import 'package:inovest/core/utils/app_routes.dart';

class NavigationHelper {
  static Future<bool?> navigateToPayment(
    BuildContext context, {
    required double amount,
    required String userId,
    required String projectId,
  }) async {
    try {
      final result = await Navigator.pushNamed(
        context,
        AppRoutes.payment,
        arguments: <String, dynamic>{
          'amount': amount,
          'userId': userId,
          'projectId': projectId,
        },
      );
      
      return result as bool?;
    } catch (e) {
      print('Navigation error: $e');
      return false;
    }
  }
} 