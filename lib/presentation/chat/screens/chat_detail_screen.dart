import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovest/business_logics/chat/chat_bloc.dart';
import 'package:inovest/business_logics/chat/chat_event.dart';
import 'package:inovest/business_logics/chat/chat_state.dart';
import 'package:inovest/business_logics/role/role_bloc.dart';
import 'package:inovest/data/models/chat.dart';
import 'package:inovest/data/models/chat_message.dart';
import 'package:inovest/data/services/socket_service.dart';
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
  final SocketService _socketService = SocketService();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _setupSocket();
    context.read<ChatBloc>().add(LoadChatMessages(widget.chat.id));
  }

  void _setupSocket() async {
      _socketService.connect();
      _socketService.joinChat(widget.chat.id);
      _socketService.onNewMessage = (message) {
        context.read<ChatBloc>().add(ReceiveMessage(message));
      };
  }

  @override
  void dispose() {
    _messageController.dispose();
    _socketService.leaveChat(widget.chat.id);
    _socketService.disconnect();
    super.dispose();
  }

  void _handleSendMessage() {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      final message = SendMessage(widget.chat.id, content, MessageType.TEXT);
      context.read<ChatBloc>().add(message);
      _messageController.clear();

      setState(() {});
    }
  }

  void _handleTyping(String value) {
    final isTyping = value.isNotEmpty;
    if (isTyping != _isTyping) {
      setState(() => _isTyping = isTyping);
      _socketService.sendTypingStatus(widget.chat.id, isTyping);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleBloc, RoleState>(
      builder: (context, roleState) {
         Color bgColor;
                if (roleState is RoleLoading || roleState is RoleInitial) {
                  bgColor = AppArray().colors[1]; 
                } else if (roleState is RoleLoaded) {
                  bgColor = roleState.role == 'INVESTOR'
                      ? AppArray().colors[0]
                      : AppArray().colors[2];
                } else {
                  bgColor = AppArray().colors[1];
                }
        return Scaffold(
          backgroundColor: AppArray().colors[1],
          appBar: AppBar(
            backgroundColor: bgColor,
            foregroundColor: AppArray().colors[1],
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: widget.chat.avatarUrl != null
                      ? NetworkImage(widget.chat.avatarUrl!)
                      : null,
                  backgroundColor: AppArray().colors[1],
                  child: widget.chat.avatarUrl == null
                      ? Icon(Icons.person, color:  bgColor)
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
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    if (state is ChatMessagesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ChatMessagesLoaded) {
                      return ListView.builder(
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
      },
    );
  }
}
