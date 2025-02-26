import 'package:inovest/core/utils/index.dart';
import 'package:inovest/data/models/chat_message.dart';

class MessageBubble extends StatefulWidget {
  final ChatMessage message;

  const MessageBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool? _isMe;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (mounted) {
      setState(() {
        _isMe = userId == widget.message.senderId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isMe == null) return const SizedBox.shrink();

    return Align(
      alignment: _isMe! ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _isMe! ? AppArray().colors[3] : AppArray().colors[1],
          borderRadius: BorderRadius.circular(16),
        ),
        child: _buildMessageContent(context),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    switch (widget.message.messageType) {
      case MessageType.IMAGE:
        return Image.network(
          widget.message.content,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        );
      case MessageType.TEXT:
      default:
        return Text(
          widget.message.content,
          style: TextStyle(
            color: _isMe! ? AppArray().colors[1] : AppArray().colors[0],
          ),
        );
    }
  }
} 