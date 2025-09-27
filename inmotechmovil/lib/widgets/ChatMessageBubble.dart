import 'package:flutter/material.dart';

class ChatMessageBubble extends StatelessWidget {
  final String text;
  final bool fromMe;
  final String? time;
  final String? avatar;

  const ChatMessageBubble({
    Key? key,
    required this.text,
    required this.fromMe,
    this.time,
    this.avatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (time != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: Text(
                time!,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          ),
        Row(
          mainAxisAlignment: fromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!fromMe && avatar != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage(avatar!),
                  radius: 20,
                ),
              ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: fromMe ? Colors.blue[400] : Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(fromMe ? 16 : 0),
                    bottomRight: Radius.circular(fromMe ? 0 : 16),
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: fromMe ? Colors.white : Colors.black87,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            if (fromMe)
              const SizedBox(width: 40),
          ],
        ),
      ],
    );
  }
}