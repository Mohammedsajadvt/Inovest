import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovest/business_logics/chat/chat_bloc.dart';
import 'package:inovest/data/models/chat.dart';
import 'package:inovest/data/models/chat_message.dart';
import 'package:inovest/data/services/socket_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../layouts/message_bubble.dart';
import '../layouts/chat_input.dart';

class ChatDetailScreen extends StatefulWidget {
  final Chat chat;

  const ChatDetailScreen({
    Key? key,
    required this.chat,
  }) : super(key: key);

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
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      _socketService.connect(userId);
      _socketService.joinChat(widget.chat.id);
      _socketService.onNewMessage = (message) {
        context.read<ChatBloc>().add(ReceiveMessage(message));
      };
    }
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
      context.read<ChatBloc>().add(
            SendMessage(widget.chat.id, content, MessageType.TEXT),
          );
      _messageController.clear();
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.chat.name),
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
                    padding: const EdgeInsets.all(16),
                    reverse: true,
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      return MessageBubble(
                        message: state.messages[index],
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