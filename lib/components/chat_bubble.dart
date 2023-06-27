import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final Decoration decoration;
  const ChatBubble({
    super.key,
    required this.message,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      padding: const EdgeInsets.all(12),
      decoration: decoration,
      child: Text(
        message,
        style: const TextStyle(fontSize: 15, color: Colors.white),
      ),
    );
  }
}
