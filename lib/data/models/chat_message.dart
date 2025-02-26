import 'package:inovest/data/models/user.dart';

enum MessageType { TEXT, IMAGE, VOICE }

class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final MessageType messageType;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.messageType,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      throw ArgumentError('json cannot be null');
    }
    return ChatMessage(
      id: json['id'] ?? '',
      chatId: json['chatId'] ?? '',
      senderId: json['senderId'] ?? '',
      content: json['content'] ?? '',
      messageType: json['messageType'] != null
          ? MessageType.values.firstWhere(
              (e) => e.toString() == 'MessageType.${json['messageType']}',
              orElse: () => MessageType.TEXT,
            )
          : MessageType.TEXT,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'messageType': messageType.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
    };
  }
} 