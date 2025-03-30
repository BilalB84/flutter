import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AiChatPage extends StatefulWidget {
  const AiChatPage({Key? key}) : super(key: key);

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  static const String openAiApiKey = 'YOUR_OPENAI_API_KEY';
  static const String endpoint = 'https://api.openai.com/v1/chat/completions';

  @override
  void initState() {
    super.initState();
    _addBotMessage("Hello! I'm your AI Coach. To create your ideal workout plan, could you tell me:
- Your fitness goal (e.g. muscle gain, fat loss, general health)
- Your training experience level (beginner, intermediate, advanced)
- Days per week you want to train
- Any preferences or limitations?");
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add({'role': 'user', 'content': text});
    });
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add({'role': 'assistant', 'content': text});
    });
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;
    _addUserMessage(message);
    _controller.clear();
    setState(() => _isLoading = true);

    final messages = [
      {"role": "system", "content": "You are a certified personal trainer AI assistant. Your job is to help users plan structured gym workouts. Always use concise, clear language. Include rest times, repetitions, and weights. Base your recommendations on scientifically approved fitness guidelines."},
      ..._messages.map((m) => {'role': m['role'], 'content': m['content']})
    ];

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $openAiApiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "temperature": 0.3,
        "messages": messages,
      }),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final reply = decoded['choices'][0]['message']['content'];
      _addBotMessage(reply.trim());
    } else {
      _addBotMessage("Sorry, I couldn't reach the AI service. Please try again later.");
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Coach')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(message['content'] ?? ''),
                  ),
                );
              },
            ),
          ),
          if (_isLoading) const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: _sendMessage,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
