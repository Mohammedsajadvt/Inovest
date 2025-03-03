import 'package:inovest/core/app_settings/secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:inovest/core/common/api_constants.dart';
import 'package:inovest/data/models/chat_message.dart';

class SocketService {
  io.Socket? socket; 
  Function(ChatMessage)? onNewMessage;
  Function(String, bool)? onTypingStatus;
  Function(String, String)? onUserStatus;
  Function(Map<String, dynamic>)? onNewNotification;

  Future<void> connect() async {
    
    final token = await SecureStorage().getToken();
    final userId = await SecureStorage().getUserId();

    socket = io.io(ApiConstants.serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'token': token},
      'query': {'userId': userId},
    });

    socket!.connect(); 

    socket!.on('connect', (_) {
      print('Connected to socket server');
    });

    socket!.on('disconnect', (_) {
      print('Disconnected from socket server');
    });

    socket!.on('new_notification', (data) {
      if (onNewNotification != null) {
        onNewNotification!(data);
      }
    });

    socket!.on('new_message', (data) {
      if (onNewMessage != null) {
        onNewMessage!(ChatMessage.fromJson(data));
      }
    });

    socket!.on('typing_status', (data) {
      if (onTypingStatus != null) {
        onTypingStatus!(data['chatId'], data['isTyping']);
      }
    });

    socket!.on('user_status', (data) {
      if (onUserStatus != null) {
        onUserStatus!(data['userId'], data['status']);
      }
    });
  }

  void joinChat(String chatId) {
    if (socket != null && socket!.connected) {
      socket!.emit('join_chat', {'chatId': chatId});
    } else {
      print('Socket is not connected. Call connect() first.');
    }
  }

  void leaveChat(String chatId) {
    if (socket != null && socket!.connected) {
      socket!.emit('leave_chat', {'chatId': chatId});
    } else {
      print('Socket is not connected.');
    }
  }

  void sendTypingStatus(String chatId, bool isTyping) {
    if (socket != null && socket!.connected) {
      socket!.emit('typing_status', {
        'chatId': chatId,
        'isTyping': isTyping,
      });
    } else {
      print('Socket is not connected.');
    }
  }

  void disconnect() {
    if (socket != null) {
      socket!.disconnect();
      socket = null; 
    }
  }
}