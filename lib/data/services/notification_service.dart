import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:inovest/core/common/api_constants.dart';
import 'package:inovest/core/app_settings/secure_storage.dart';
import 'dart:convert';
import 'package:inovest/core/utils/logger.dart';
import 'package:inovest/core/app_settings/unauthorized_notifier.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    try {
      const androidChannel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );

      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);

      const initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const initializationSettingsIOS = DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
      );
      
      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _handleNotificationTap,
      );

      Future.delayed(Duration(seconds: 2), () async {
        try {
          await _firebaseMessaging.requestPermission(
            alert: true,
            badge: true,
            sound: true,
            provisional: false,
          );

          String? token = await _firebaseMessaging.getToken();
          if (token != null) {
            await updateFcmToken(token);
            Logger.log('FCM Token: $token');
          }

          _firebaseMessaging.onTokenRefresh.listen(updateFcmToken);
          FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
          FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
        } catch (e) {
          Logger.log('Error setting up FCM: $e');
        }
      });

    } catch (e) {
      Logger.log('Error initializing notifications: $e');
    }
  }

  Future<void> _handleNotificationTap(NotificationResponse details) async {
    if (details.payload != null) {
      Logger.log('Notification tapped with payload: ${details.payload}');
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    Logger.log('Received foreground message: ${message.notification?.title}');
    
    await _showLocalNotification(
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      payload: message.data['route'],
    );
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    Logger.log('App opened from notification: ${message.notification?.title}');
  }

  Future<void> _showLocalNotification(
    String title,
    String body, {
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      details,
      payload: payload,
    );
  }

  Future<void> updateFcmToken(String token) async {
    try {
      final String? accessToken = await SecureStorage().getToken();
      if (accessToken == null) return;

      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/fcm-token"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({"token": token}),
      );

      if (response.statusCode == 401) {
        await SecureStorage().clearTokenAndRole();
        UnauthorizedNotifier().notifyUnauthorized();
        return;
      }

      if (response.statusCode != 200) {
        Logger.log('Failed to update FCM token: ${response.body}');
      }
    } catch (e) {
      Logger.log('Error updating FCM token: $e');
    }
  }
}