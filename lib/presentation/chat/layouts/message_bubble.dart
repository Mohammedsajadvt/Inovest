import 'package:inovest/core/utils/index.dart';
import 'package:inovest/data/models/chat_message.dart';
import 'package:inovest/core/utils/user_utils.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatefulWidget {
  final ChatMessage message;
  final bool isSeen;

  const MessageBubble({
    super.key,
    required this.message,
    this.isSeen = false,
  });

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
    final userId = await UserUtils.getCurrentUserId();
    if (mounted) {
      setState(() {
        _isMe = userId == widget.message.senderId;
      });
    }
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  Widget _buildAvatar(bool isMe) {
    final imageUrl = widget.message.sender?.imageUrl;
    final name = widget.message.sender?.name ?? '';

    return CircleAvatar(
      radius: 16.r,
      backgroundColor: isMe 
        ? AppArray().colors[0].withValues(alpha: 0.2 * 255)
        : AppArray().colors[3].withValues(alpha: 0.2 * 255),
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
      child: imageUrl == null
        ? Text(
            name.isNotEmpty ? name[0].toUpperCase() : '',
            style: TextStyle(
              color: isMe ? AppArray().colors[0] : AppArray().colors[3],
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          )
        : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isMe == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
      child: Column(
        crossAxisAlignment: _isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!_isMe! && widget.message.sender?.name != null) ...[
            Padding(
              padding: EdgeInsets.only(left: 48.w, bottom: 4.h),
              child: Text(
                widget.message.sender!.name,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppArray().colors[3],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          Row(
            mainAxisAlignment: _isMe! ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!_isMe!) ...[
                _buildAvatar(false),
                SizedBox(width: 8.w),
              ],
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  decoration: BoxDecoration(
                    color: _isMe! 
                      ? AppArray().colors[0]
                      : Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                      bottomLeft: Radius.circular(_isMe! ? 20.r : 0),
                      bottomRight: Radius.circular(_isMe! ? 0 : 20.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMessageContent(context),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _formatTime(widget.message.createdAt),
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: _isMe! 
                                ? AppArray().colors[1].withOpacity(0.7)
                                : Colors.grey[600],
                            ),
                          ),
                          if (_isMe!) ...[
                            SizedBox(width: 4.w),
                            Icon(
                              widget.isSeen ? Icons.done_all : Icons.done,
                              size: 14.r,
                              color: widget.isSeen 
                                ? AppArray().colors[1]
                                : AppArray().colors[1].withOpacity(0.7),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (_isMe!) ...[
                SizedBox(width: 8.w),
                _buildAvatar(true),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    switch (widget.message.messageType) {
      case MessageType.IMAGE:
        return ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.network(
            widget.message.content,
            width: 200.w,
            height: 200.w,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 200.w,
                height: 200.w,
                color: Colors.grey[300],
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: _isMe! ? AppArray().colors[1] : AppArray().colors[0],
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 200.w,
                height: 200.w,
                color: Colors.grey[300],
                child: Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 40.r,
                ),
              );
            },
          ),
        );
      case MessageType.TEXT:
      default:
        return Text(
          widget.message.content,
          style: TextStyle(
            fontSize: 14.sp,
            color: _isMe! ? AppArray().colors[1] : AppArray().colors[0],
            height: 1.3,
          ),
        );
    }
  }
} 