import 'package:inovest/data/models/chat_message.dart';

abstract class ChatEvent {}

class LoadChats extends ChatEvent {}

class LoadChatMessages extends ChatEvent {
  final String chatId;
  LoadChatMessages(this.chatId);
}

class SendMessage extends ChatEvent {
  final String chatId;
  final String content;
  final MessageType messageType;
  SendMessage(this.chatId, this.content, this.messageType);
}

class ReceiveMessage extends ChatEvent {
  final ChatMessage message;
  ReceiveMessage(this.message);
}

class InitializeChat extends ChatEvent {
  final String investorId;
  final String projectId;
  InitializeChat(this.investorId, this.projectId);
}