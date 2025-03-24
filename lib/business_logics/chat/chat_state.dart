import 'package:inovest/data/models/chat.dart';
import 'package:inovest/data/models/chat_message.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatsLoading extends ChatState {}

class ChatsLoaded extends ChatState {
  final List<Chat> chats;
  ChatsLoaded(this.chats);
}

class ChatMessagesLoading extends ChatState {}

class ChatMessagesLoaded extends ChatState {
  final List<ChatMessage> messages;
  ChatMessagesLoaded(this.messages);
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}

class ChatInitialized extends ChatState {
  final Chat chat;
  ChatInitialized(this.chat);
}