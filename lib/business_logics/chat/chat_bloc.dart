import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovest/data/models/chat.dart';
import 'package:inovest/data/models/chat_message.dart';
import 'package:inovest/data/services/chat_service.dart';

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

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService _chatService;

  ChatBloc(this._chatService) : super(ChatInitial()) {
    on<LoadChats>(_onLoadChats);
    on<LoadChatMessages>(_onLoadChatMessages);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
  }

  Future<void> _onLoadChats(LoadChats event, Emitter<ChatState> emit) async {
    emit(ChatsLoading());
    try {
      final chats = await _chatService.getChats();
      emit(ChatsLoaded(chats));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onLoadChatMessages(LoadChatMessages event, Emitter<ChatState> emit) async {
    emit(ChatMessagesLoading());
    try {
      final messages = await _chatService.getChatMessages(event.chatId);
      emit(ChatMessagesLoaded(messages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    try {
      final message = await _chatService.sendMessage(
        event.chatId,
        event.content,
        event.messageType,
      );
      if (state is ChatMessagesLoaded) {
        final currentMessages = (state as ChatMessagesLoaded).messages;
        emit(ChatMessagesLoaded([...currentMessages, message]));
      }
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _onReceiveMessage(ReceiveMessage event, Emitter<ChatState> emit) {
    if (state is ChatMessagesLoaded) {
      final currentMessages = (state as ChatMessagesLoaded).messages;
      emit(ChatMessagesLoaded([...currentMessages, event.message]));
    }
  }
} 