import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:app_links/app_links.dart';

class DeepLinkService {
  static final AppLinks _appLinks = AppLinks();

  static Future<void> setupDeepLinks(BuildContext context) async {
    if (kIsWeb) {
      _handleWebDeepLink(context);
    } else {
      await _handleMobileDeepLink(context);
    }
  }

  static Future<void> _handleMobileDeepLink(BuildContext context) async {
    try {
      final Uri? initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(context, initialLink);
      }

      _appLinks.uriLinkStream.listen(
        (Uri? link) {
          if (link != null) {
            _handleDeepLink(context, link);
          }
        },
        onError: (err) {
          print('Deep link stream error: $err');
          _showError(context, 'Error processing deep link');
        },
      );
    } on PlatformException catch (e) {
      print('Failed to get initial link: ${e.message}');
      _showError(context, 'Failed to process deep link');
    }
  }

  static void _handleWebDeepLink(BuildContext context) {
    if (!kIsWeb) return;

    final uri = Uri.base; 
    print('Web deep link: $uri');

    if (uri.path == '/reset-password') {
      final token = uri.queryParameters['token'];
      if (token != null && token.isNotEmpty) {
        Navigator.pushNamed(context, '/reset-password', arguments: token);
      }
    }
  }

  static void _handleDeepLink(BuildContext context, Uri link) {
    print('Handling deep link: $link');

    if (link.path == '/reset-password') {
      final token = link.queryParameters['token'];
      if (token != null && token.isNotEmpty) {
        Navigator.pushNamed(context, '/reset-password', arguments: token);
      } else {
        _showError(context, 'Invalid reset token');
      }
    }
  }

  static void _showError(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
