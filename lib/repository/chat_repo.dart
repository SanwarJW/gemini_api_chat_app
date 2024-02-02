import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemini_api_chat_app/models/chat_message.dart';

class ChatRepo {
  static Future<String> chatTextGenerationRepo(
      List<ChatMessage> previousMessage) async {
    final dio = Dio();
    String key = dotenv.get('API_KEY', fallback: "");

    try {
      final response = await dio.post(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$key',
          data: {
            "contents":
                previousMessage.map((element) => element.toMap()).toList(),
            "generationConfig": {
              "temperature": 0.9,
              "topK": 1,
              "topP": 1,
              "maxOutputTokens": 2048,
              "stopSequences": []
            },
            "safetySettings": [
              {
                "category": "HARM_CATEGORY_HARASSMENT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              },
              {
                "category": "HARM_CATEGORY_HATE_SPEECH",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              },
              {
                "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              },
              {
                "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              }
            ]
          });
      log(response.toString());
      String res =
          response.data["candidates"].first["content"]["parts"].first["text"];
      return res;
    } catch (e) {
      print('error');
      log(e.toString());
    }
    return '';
  }
}
