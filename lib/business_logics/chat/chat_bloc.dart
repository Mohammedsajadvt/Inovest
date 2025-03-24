import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovest/business_logics/chat/chat_event.dart';
import 'package:inovest/business_logics/chat/chat_state.dart';
import 'package:inovest/data/services/chat_service.dart';
import 'package:inovest/data/services/socket_service.dart';
import 'package:inovest/data/models/chat.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService _chatService;
  final SocketService _socketService;
  String? _currentChatId;

  ChatBloc(this._chatService) 
    : _socketService = SocketService(),
      super(ChatInitial()) {
    on<LoadChats>(_onLoadChats);
    on<LoadChatMessages>(_onLoadChatMessages);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
    on<InitializeChat>(_onInitializeChat);

    // Set up socket listeners
    _socketService.onNewMessage = (message) {
      if (_currentChatId == message.chatId) {
        add(ReceiveMessage(message));
      }
    };
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
      _currentChatId = event.chatId;
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
      
      _socketService.emitMessage(event.chatId, message);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _onReceiveMessage(ReceiveMessage event, Emitter<ChatState> emit) {
    if (state is ChatMessagesLoaded) {
      final currentMessages = (state as ChatMessagesLoaded).messages;
      
      if (!currentMessages.any((m) => m.id == event.message.id)) {
        emit(ChatMessagesLoaded([...currentMessages, event.message]));
      }
    }
  }

  Future<void> _onInitializeChat(InitializeChat event, Emitter<ChatState> emit) async {
    try {
      // Join the chat room
      _socketService.joinChat(event.projectId);
      _currentChatId = event.projectId;
      
      emit(ChatInitialized(Chat(
        id: event.projectId,
        projectId: event.projectId,
        project: Project(id: event.projectId, title: ''),
        participants: [],
        messages: [],
        createdAt: DateTime.now(),
      )));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
} 