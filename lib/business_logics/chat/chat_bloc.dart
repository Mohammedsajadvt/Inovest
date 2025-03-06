import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovest/business_logics/chat/chat_event.dart';
import 'package:inovest/business_logics/chat/chat_state.dart';
import 'package:inovest/data/services/chat_service.dart';




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