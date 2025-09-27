import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onCameraTap;
  final VoidCallback? onSendTap;

  const ChatInputBar({
    Key? key,
    required this.controller,
    this.onCameraTap,
    this.onSendTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color customBarColor = const Color(0xFF6B8796);
    final Color inputFieldColor = const Color(0xFFB0C4CE);

    return Container(
      color: customBarColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.white70),
            onPressed: onCameraTap,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: inputFieldColor,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: controller,
                style: const TextStyle(color: Colors.black87),
                decoration: const InputDecoration(
                  hintText: "Type message here...",
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: onSendTap,
          ),
        ],
      ),
    );
  }
}