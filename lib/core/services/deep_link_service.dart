import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;

class DeepLinkService {
  static Future<void> setupDeepLinks(BuildContext context) async {
    if (kIsWeb) {
      _handleWebDeepLink(context);
    } else {
      try {
        final initialLink = await getInitialLink();
        if (initialLink != null) {
          _handleDeepLink(context, initialLink);
        }
        
        linkStream.listen(
          (String? link) {
            if (link != null) {
              _handleDeepLink(context, link);
            }
          },
          onError: (err) {
            print('Deep link stream error: $err');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error processing deep link: $err'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        );
      } on PlatformException catch (e) {
        print('Failed to get initial deep link: ${e.message}');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to process deep link: ${e.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  static void _handleWebDeepLink(BuildContext context) {
    if (!kIsWeb) return;

    final uri = Uri.parse(html.window.location.href);
    final hash = uri.fragment;

    if (hash.isNotEmpty) {
      final hashUri = Uri.parse(hash);
      if (hashUri.path == '/reset-password') {
        final token = hashUri.queryParameters['token'];
        if (token != null && token.isNotEmpty) {
          print('Found reset token: $token'); // Debug log
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamed(
              context,
              '/reset-password',
              arguments: token,
            );
          });
        } else {
          print('No token found in URL');
        }
      }
    }

    html.window.onHashChange.listen((_) {
      final newUri = Uri.parse(html.window.location.href);
      final newHash = newUri.fragment;

      if (newHash.isNotEmpty) {
        final hashUri = Uri.parse(newHash);
        if (hashUri.path == '/reset-password') {
          final token = hashUri.queryParameters['token'];
          if (token != null && token.isNotEmpty) {
            Navigator.pushNamed(
              context,
              '/reset-password',
              arguments: token,
            );
          }
        }
      }
    });
  }

  static void _handleDeepLink(BuildContext context, String link) {
    try {
      final uri = Uri.parse(link);
      
      print('Handling deep link: $link');
      
      if (uri.path == '/reset-password') {
        final token = uri.queryParameters['token'];
        if (token != null && token.isNotEmpty) {
          Navigator.pushNamed(
            context,
            '/reset-password',
            arguments: token,
          );
        } else {
          throw Exception('Reset password token is missing or empty');
        }
      }
    } catch (e) {
      print('Error processing deep link: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid deep link format'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
