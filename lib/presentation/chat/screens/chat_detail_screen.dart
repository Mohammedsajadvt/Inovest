import 'package:flutter/material.dart';
import '../../../data/models/chat.dart';
import '../../../data/models/message.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input.dart';

class ChatDetailScreen extends StatelessWidget {
  final Chat chat;

  const ChatDetailScreen({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(chat.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: true,
              itemCount: _dummyMessages.length,
              itemBuilder: (context, index) {
                return MessageBubble(
                  message: _dummyMessages[index],
                );
              },
            ),
          ),
          const ChatInput(),
        ],
      ),
    );
  }

  static final List<Message> _dummyMessages = [
    Message(
      id: '2',
      senderId: '1',
      content: 'So excited!',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isMe: false,
    ),
     Message(
      id: '1',
      senderId: '2',
      content: 'Hello, how are you?',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isMe: true,
    ),
  ];
} 