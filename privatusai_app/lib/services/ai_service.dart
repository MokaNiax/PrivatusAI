import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:privatusai/l10n/app_localizations.dart';

class AIService {
  final String? apiKey;
  final String aiServiceType;
  final String aiModel;
  final BuildContext context;

  AIService({required this.apiKey, required this.aiServiceType, required this.aiModel, required this.context});

  String _getBaseUrl() {
    switch (aiServiceType) {
      case 'OpenAI':
        return 'https://api.openai.com/v1/chat/completions';
      case 'Gemini':
        return 'https://generativelanguage.googleapis.com/v1beta/models/$aiModel:generateContent';
      default:
        return 'https://api.openai.com/v1/chat/completions';
    }
  }

  List<Map<String, dynamic>> _formatMessagesForGemini(List<Map<String, String>> messages) {
    final localizations = AppLocalizations.of(context)!;
    List<Map<String, dynamic>> formattedMessages = [];
    formattedMessages.add({
      'role': 'user',
      'parts': [{'text': localizations.geminiSystemPrompt}]
    });
    formattedMessages.add({'role': 'model', 'parts': [{'text': localizations.geminiAssistantResponse}]});


    for (var msg in messages) {
      if (msg['role'] == 'user') {
        formattedMessages.add({'role': 'user', 'parts': [{'text': msg['text']}]});
      } else if (msg['role'] == 'ai') {
        formattedMessages.add({'role': 'model', 'parts': [{'text': msg['text']}]});
      }
    }
    return formattedMessages;
  }

  Future<String> getAIResponse(List<Map<String, String>> messages) async {
    final localizations = AppLocalizations.of(context)!;

    if (apiKey == null || apiKey!.isEmpty) {
      throw Exception(localizations.apiKeyNotSetError);
    }

    final String url = _getBaseUrl();

    Map<String, dynamic> requestBody;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (aiServiceType == 'OpenAI') {
      headers['Authorization'] = 'Bearer $apiKey';

      List<Map<String, String>> messagesWithSystemPrompt = [
        {'role': 'system', 'text': localizations.openAISystemPrompt},
        {'role': 'assistant', 'text': localizations.openAIAssistantResponse},
        ...messages,
      ];

      requestBody = {
        'model': aiModel,
        'messages': messagesWithSystemPrompt,
      };
    } else if (aiServiceType == 'Gemini') {
      headers['x-goog-api-key'] = apiKey!;
      requestBody = {
        'contents': _formatMessagesForGemini(messages),
      };
    } else {
      throw Exception(localizations.unsupportedAIServiceType(aiServiceType));
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (aiServiceType == 'OpenAI') {
          return data['choices'][0]['message']['content'];
        } else if (aiServiceType == 'Gemini') {
          if (data['candidates'] != null &&
              data['candidates'].isNotEmpty &&
              data['candidates'][0]['content'] != null &&
              data['candidates'][0]['content']['parts'] != null &&
              data['candidates'][0]['content']['parts'].isNotEmpty &&
              data['candidates'][0]['content']['parts'][0]['text'] != null) {
            return data['candidates'][0]['content']['parts'][0]['text'];
          } else {
            return localizations.geminiResponseNotFound;
          }
        } else {
          return localizations.noContentFound;
        }
      } else {
        throw Exception('${localizations.failedToLoadAIResponse}: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('${localizations.errorCommunicatingWithAI}: $e');
    }
  }
}