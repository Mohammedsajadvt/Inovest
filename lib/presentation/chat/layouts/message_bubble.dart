import 'package:flutter/material.dart';
import 'package:inovest/core/common/app_array.dart';
import '../../../data/models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: message.isMe ? AppArray().colors[3] : AppArray().colors[1],
          borderRadius: BorderRadius.circular(16),
        ),
        child: _buildMessageContent(context),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    switch (message.type) {
      case MessageType.image:
        return Image.network(
          message.content,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        );
      case MessageType.link:
      case MessageType.text:
      return Text(
          message.content,
          style: TextStyle(
            color: message.isMe ? AppArray().colors[1] : AppArray().colors[0],
          ),
        );
    }
  }
} 