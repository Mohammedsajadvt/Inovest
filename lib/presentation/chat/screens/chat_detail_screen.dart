import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovest/business_logics/chat/chat_bloc.dart';
import 'package:inovest/business_logics/chat/chat_event.dart';
import 'package:inovest/business_logics/chat/chat_state.dart';
import 'package:inovest/business_logics/role/role_bloc.dart';
import 'package:inovest/data/models/chat.dart';
import 'package:inovest/data/models/chat_message.dart';
import 'package:inovest/core/common/app_array.dart';
import '../layouts/message_bubble.dart';
import '../layouts/chat_input.dart';

class ChatDetailScreen extends StatefulWidget {
  final Chat chat;

  const ChatDetailScreen({
    super.key,
    required this.chat,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isTyping = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _setupChat();
  }

  void _setupChat() {
    // Load messages and join chat room
    context.read<ChatBloc>()
      ..add(LoadChatMessages(widget.chat.id))
      ..add(InitializeChat(widget.chat.projectId, widget.chat.id));
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSendMessage() {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      context.read<ChatBloc>().add(
        SendMessage(widget.chat.id, content, MessageType.TEXT),
      );
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _handleTyping(String value) {
    final isTyping = value.isNotEmpty;
    if (isTyping != _isTyping) {
      setState(() => _isTyping = isTyping);
      // Typing status will be handled by the ChatBloc
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundImage: widget.chat.avatarUrl != null
                  ? NetworkImage(widget.chat.avatarUrl!)
                  : null,
              backgroundColor: AppArray().colors[1],
              child: widget.chat.avatarUrl == null
                  ? Icon(Icons.person, color: AppArray().colors[1])
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chat.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (_isTyping) ...[
                    Text(
                      'typing...',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppArray().colors[1].withOpacity(0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
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
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatMessagesLoaded) {
                  _scrollToBottom();
                }
              },
              builder: (context, state) {
                if (state is ChatMessagesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatMessagesLoaded) {
                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(16.r),
                    reverse: true,
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final isLastMessage = index == 0;
                      final isSeen = isLastMessage && !widget.chat.unread;
                      return MessageBubble(
                        message: message,
                        isSeen: isSeen,
                      );
                    },
                  );
                } else if (state is ChatError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          ChatInput(
            controller: _messageController,
            onChanged: _handleTyping,
            onSend: _handleSendMessage,
          ),
        ],
      ),
    );
  }
}
