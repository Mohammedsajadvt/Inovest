import 'package:flutter/material.dart';
import 'package:inovest/core/common/app_array.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback onSend;

  const ChatInput({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.onSend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: AppArray().colors[1].withAlpha(51)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: 'Message',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
} 