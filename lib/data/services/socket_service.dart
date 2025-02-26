import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:inovest/core/common/api_constants.dart';
import 'package:inovest/data/models/chat_message.dart';

class SocketService {
  late io.Socket socket;
  Function(ChatMessage)? onNewMessage;
  Function(String, bool)? onTypingStatus;
  Function(String, String)? onUserStatus;

  void connect(String userId) {
    socket = io.io(ApiConstants.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {'userId': userId},
    });

    socket.connect();

    socket.on('connect', (_) {
      print('Connected to socket server');
    });

    socket.on('disconnect', (_) {
      print('Disconnected from socket server');
    });

    socket.on('new_message', (data) {
      if (onNewMessage != null) {
        onNewMessage!(ChatMessage.fromJson(data));
      }
    });

    socket.on('typing_status', (data) {
      if (onTypingStatus != null) {
        onTypingStatus!(data['chatId'], data['isTyping']);
      }
    });

    socket.on('user_status', (data) {
      if (onUserStatus != null) {
        onUserStatus!(data['userId'], data['status']);
      }
    });
  }

  void joinChat(String chatId) {
    socket.emit('join_chat', {'chatId': chatId});
  }

  void leaveChat(String chatId) {
    socket.emit('leave_chat', {'chatId': chatId});
  }

  void sendTypingStatus(String chatId, bool isTyping) {
    socket.emit('typing_status', {
      'chatId': chatId,
      'isTyping': isTyping,
    });
  }

  void disconnect() {
    socket.disconnect();
  }
} 