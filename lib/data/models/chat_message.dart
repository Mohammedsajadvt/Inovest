import 'package:inovest/data/models/user.dart';

enum MessageType { TEXT, IMAGE, VOICE }

class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final MessageType messageType;
  final DateTime createdAt;
  final User? sender;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.messageType,
    required this.createdAt,
    this.sender,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    try {
      return ChatMessage(
        id: json['id'] as String? ?? '',
        chatId: json['chatId'] as String? ?? '',
        senderId: json['senderId'] as String? ?? '',
        content: json['content'] as String? ?? '',
        messageType: json['messageType'] != null
            ? MessageType.values.firstWhere(
                (e) => e.toString() == 'MessageType.${json['messageType']}',
                orElse: () => MessageType.TEXT,
              )
            : MessageType.TEXT,
        createdAt: json['createdAt'] != null 
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.now(),
        sender: json['sender'] != null 
            ? User.fromJson(json['sender'] as Map<String, dynamic>)
            : null,
      );
    } catch (e, stackTrace) {
      print('Error parsing ChatMessage: $e');
      print('Stack trace: $stackTrace');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'messageType': messageType.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      if (sender != null) 'sender': sender!.toJson(),
    };
  }
} 