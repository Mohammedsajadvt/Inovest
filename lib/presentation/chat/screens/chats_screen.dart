import 'package:flutter/material.dart';
import 'package:inovest/core/common/app_array.dart';
import '../widgets/chat_list_item.dart';
import '../../../data/models/chat.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              hintText: 'Search',
              leading: const Icon(Icons.search),
              backgroundColor: WidgetStateProperty.all(AppArray().colors[1]),
            ),
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _dummyChats.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ChatListItem(chat: _dummyChats[index]);
        },
      ),
    );
  }

  static final List<Chat> _dummyChats = [
    Chat(
      id: '1',
      name: 'John Doe',
      lastMessage: 'What should we make?',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      unread: true,
    ),
    Chat(
      id: '2',
      name: 'MH',
      lastMessage: 'I need help with the project.',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
      unread: false,
    ),
  ];
} 