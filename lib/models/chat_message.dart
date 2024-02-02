import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatMessage {
  final String role;
  final List<Parts> parts;
  ChatMessage({
    required this.role,
    required this.parts,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'role': role,
      'parts': parts.map((x) => x.toMap()).toList(),
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      role: map['role'] as String,
      parts: List<Parts>.from(
        (map['parts'] as List<int>).map<Parts>(
          (x) => Parts.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Parts {
  final String text;
  Parts({
    required this.text,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
    };
  }

  factory Parts.fromMap(Map<String, dynamic> map) {
    return Parts(
      text: map['text'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Parts.fromJson(String source) =>
      Parts.fromMap(json.decode(source) as Map<String, dynamic>);
}
