import 'package:inovest/data/models/chat_message.dart';
import 'package:inovest/data/models/user.dart';

class Chat {
  final String id;
  final String projectId;
  final Project project;
  final List<Participant> participants;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  final bool unread;

  Chat({
    required this.id,
    required this.projectId,
    required this.project,
    required this.participants,
    required this.messages,
    required this.createdAt,
    this.unread = false,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    try {
      final projectData = json['project'];
      if (projectData == null) {
        throw ArgumentError('Project data is missing');
      }

      final participantsData = json['participants'];
      if (participantsData == null) {
        throw ArgumentError('Participants data is missing');
      }

      return Chat(
        id: json['id'] as String? ?? '',
        projectId: json['projectId'] as String? ?? '',
        project: Project.fromJson(projectData as Map<String, dynamic>),
        participants: (participantsData as List)
            .map((p) => Participant.fromJson(p as Map<String, dynamic>))
            .toList(),
        messages: (json['messages'] as List?)
            ?.map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
            .toList() ?? [],
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.now(),
        unread: json['unread'] as bool? ?? false,
      );
    } catch (e, stackTrace) {
      print('Error parsing Chat: $e');
      print('Stack trace: $stackTrace');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'project': project.toJson(),
      'participants': participants.map((p) => p.toJson()).toList(),
      'messages': messages.map((m) => m.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'unread': unread,
    };
  }

  String get lastMessage => messages.isNotEmpty ? messages.last.content : '';
  DateTime get lastMessageTime => messages.isNotEmpty ? messages.last.createdAt : createdAt;
  String get name => project.title;
  String? get avatarUrl => participants.length == 1 ? participants.first.user.imageUrl : null;
}

class Project {
  final String id;
  final String title;

  Project({
    required this.id,
    required this.title,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    try {
      if (json['id'] == null) {
        throw ArgumentError('Project id is missing');
      }
      if (json['title'] == null) {
        throw ArgumentError('Project title is missing');
      }

      return Project(
        id: json['id'] as String,
        title: json['title'] as String,
      );
    } catch (e, stackTrace) {
      print('Error parsing Project: $e');
      print('Stack trace: $stackTrace');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}

class Participant {
  final String id;
  final String chatId;
  final String userId;
  final DateTime createdAt;
  final User user;

  Participant({
    required this.id,
    required this.chatId,
    required this.userId,
    required this.createdAt,
    required this.user,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    try {
      final userData = json['user'];
      if (userData == null) {
        throw ArgumentError('User data is missing in participant');
      }

      return Participant(
        id: json['id'] as String? ?? '',
        chatId: json['chatId'] as String? ?? '',
        userId: json['userId'] as String? ?? '',
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.now(),
        user: User.fromJson(userData as Map<String, dynamic>),
      );
    } catch (e, stackTrace) {
      print('Error parsing Participant: $e');
      print('Stack trace: $stackTrace');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'user': user.toJson(),
    };
  }
} 