import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final String apiKey = 'xksksk-sdfdsfd0dsfsdf-sdfsdfds'; // Replace with your OpenAI API key
  List<Message> messages = [];

  ChatBloc() : super(ChatInitial()) {
    on<SendMessageEvent>((event, emit) async {
      emit(ChatLoading());
      messages.add(Message(event.message, true));
      try {
        final response = await _callOpenAIApi(event.message);
        messages.add(Message(response, false));
        emit(ChatLoaded(List.from(messages)));
      } catch (e) {
        emit(ChatError('Failed to get response: $e'));
      }
    });
  }

  Future<String> _callOpenAIApi(String message) async {
    final response = await http.post(
      Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'meta-llama/llama-4-scout-17b-16e-instruct',
        'messages': [
          {'role': 'user', 'content': message}
        ],
        // 'max_tokens': 150,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
        String content = data['choices'][0]['message']['content'].trim();
        // Sanitize the response: replace newlines and control characters
        content = content
            .replaceAll('\n', ' ') // Replace newlines with spaces
            .replaceAll('\r', '')  // Remove carriage returns
            .replaceAll(RegExp(r'[^\x20-\x7E]'), ''); // Remove non-printable ASCII characters
        return content;
    } else {
      throw Exception('Failed to connect to OpenAI API');
    }
  }
}