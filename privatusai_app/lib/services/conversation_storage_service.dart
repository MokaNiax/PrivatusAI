import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:privatusai/models/conversation.dart';

class ConversationStorageService {
  static const String _conversationsKey = 'conversations';

  Future<List<Conversation>> loadConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final String? conversationsJson = prefs.getString(_conversationsKey);
    if (conversationsJson == null) {
      return [];
    }
    final List<dynamic> jsonList = json.decode(conversationsJson);
    return jsonList.map((json) => Conversation.fromJson(json)).toList();
  }

  Future<void> saveConversations(List<Conversation> conversations) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList =
    conversations.map((conv) => conv.toJson()).toList();
    await prefs.setString(_conversationsKey, json.encode(jsonList));
  }
}