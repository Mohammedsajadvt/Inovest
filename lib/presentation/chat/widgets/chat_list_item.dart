import 'package:flutter/material.dart';
import 'package:inovest/core/common/app_array.dart';
import '../../../data/models/chat.dart';
import '../screens/chat_detail_screen.dart';

class ChatListItem extends StatelessWidget {
  final Chat chat;

  const ChatListItem({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(chat: chat),
          ),
        );
      },
      leading: CircleAvatar(
        backgroundColor: AppArray().colors[1].withAlpha(51),
        backgroundImage: chat.avatarUrl != null
            ? NetworkImage(chat.avatarUrl!)
            : null,
        child: chat.avatarUrl == null
            ? Text(chat.name[0].toUpperCase())
            : null,
      ),
      title: Text(
        chat.name,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(
        chat.lastMessage,
        style: Theme.of(context).textTheme.bodyMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: chat.unread
          ? Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppArray().colors[6],
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
} 