import 'dart:convert';

class Conversation {
  String id;
  String title;
  List<Map<String, String>> messages;
  DateTime createdAt;

  Conversation({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawMessages = json['messages'] ?? [];
    final List<Map<String, String>> parsedMessages = rawMessages.map((msg) {
      if (msg is Map<dynamic, dynamic>) {
        return {
          'role': msg['role']?.toString() ?? '',
          'text': msg['text']?.toString() ?? '',
        };
      }
      return {'role': '', 'text': ''};
    }).toList();

    return Conversation(
      id: json['id'],
      title: json['title'],
      messages: parsedMessages,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}