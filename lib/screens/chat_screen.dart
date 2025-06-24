import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return BlocProvider(
      create: (context) => ChatBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Chatbot')),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatInitial) {
                    return const Center(child: Text('Start chatting!'));
                  } else if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChatLoaded) {
                    return ListView.builder(
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        return ListTile(
                          title: Align(
                            alignment: message.isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: message.isUser ? Colors.blue[100] : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(message.text),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is ChatError) {
                    return Center(child: Text(state.error));
                  }
                  return Container();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Builder(
                builder: (newContext) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(hintText: 'Enter your message'),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            newContext.read<ChatBloc>().add(SendMessageEvent(_controller.text));
                            _controller.clear();
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}