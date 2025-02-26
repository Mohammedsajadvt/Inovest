import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inovest/core/common/api_constants.dart';
import 'package:inovest/core/utils/index.dart';
import 'package:inovest/data/models/chat.dart';
import 'package:inovest/data/models/chat_message.dart';
import 'package:inovest/core/app_settings/secure_storage.dart';

class ChatService {
  final http.Client _client;
  final SecureStorage _secureStorage;

  ChatService({http.Client? client}) 
    : _client = client ?? http.Client(),
      _secureStorage = SecureStorage();

  Future<List<Chat>> getChats() async {
    final token = await _secureStorage.getToken();

    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}/investor/chats'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['success'] == true && responseData['data'] != null) {
        final List<dynamic> chatsData = responseData['data'];
        return chatsData.map((json) => Chat.fromJson(json)).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load chats');
    }
  }

  Future<List<ChatMessage>> getChatMessages(String chatId) async {
    final token = await _secureStorage.getToken();

    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}/chats/$chatId/messages'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['success'] == true && responseData['data'] != null) {
        final List<dynamic> messagesData = responseData['data'];
        return messagesData.map((json) => ChatMessage.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load chat messages');
    }
  }

  Future<ChatMessage> sendMessage(String chatId, String content, MessageType messageType) async {
    final token = await _secureStorage.getToken();

    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await _client.post(
      Uri.parse('${ApiConstants.baseUrl}/chats/$chatId/messages'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'content': content,
        'messageType': messageType.toString().split('.').last,
      }),
    );

    if (response.statusCode == 201) {
      return ChatMessage.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to send message');
    }
  }
} 