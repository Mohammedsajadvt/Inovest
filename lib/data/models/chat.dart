class Chat {
  final String id;
  final String name;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String? avatarUrl;
  final bool unread;

  Chat({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    this.avatarUrl,
    this.unread = false,
  });
} 