import 'package:flutter/material.dart';
import 'chat_page.dart';

class ComunicacionPage extends StatelessWidget {
  const ComunicacionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chats = [
      {
        "name": "Gina David",
        "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
        "time": "10:30am",
        "avatar": "assets/avatar1.png",
      },
      {
        "name": "Julienne Mark",
        "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
        "time": "Yesterday, 11:05am",
        "avatar": "assets/avatar2.png",
      },
      {
        "name": "John Stewart",
        "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
        "time": "September 9, 2014",
        "avatar": "assets/avatar3.png",
      },
      {
        "name": "Buddy Holly",
        "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
        "time": "September 7, 2014",
        "avatar": "assets/avatar4.png",
      },
      {
        "name": "Martha Kimbley",
        "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
        "time": "July 11, 2014",
        "avatar": "assets/avatar5.png",
      },
      {
        "name": "Tina Minelli",
        "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
        "time": "June 30, 2014",
        "avatar": "assets/avatar6.png",
      },
      {
        "name": "jonathan rendon",
        "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
        "time": "June 30, 2014",
        "avatar": "assets/avatar6.png",
      },
    ];

    return ListView.separated(
      itemCount: chats.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(chat["avatar"]!),
            radius: 28,
          ),
          title: Text(
            chat["name"]!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            chat["message"]!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            chat["time"]!,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  name: chat["name"]!,
                  avatar: chat["avatar"]!,
                ),
              ),
            );
          },
        );
      },
    );
  }
}