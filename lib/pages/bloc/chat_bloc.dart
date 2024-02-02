import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gemini_api_chat_app/models/chat_message.dart';
import 'package:gemini_api_chat_app/repository/chat_repo.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatSuccessState(messages: [])) {
    on<ChatGenerateNewTextMessageEvent>(chatGenerateNewTextMessageEvent);
  }
  bool loading = false;
  List<ChatMessage> messages = [];
  Future<FutureOr<void>> chatGenerateNewTextMessageEvent(
      ChatGenerateNewTextMessageEvent event, Emitter<ChatState> emit) async {
    messages.add(
        ChatMessage(role: 'user', parts: [Parts(text: event.inputMessage)]));
    emit(ChatSuccessState(messages: messages));
    loading = true;
    String generatedText = await ChatRepo.chatTextGenerationRepo(messages);
    if (generatedText.isNotEmpty) {
      messages
          .add(ChatMessage(role: 'model', parts: [Parts(text: generatedText)]));
      loading = false;
      emit(ChatSuccessState(messages: messages));
    }
  }
}
