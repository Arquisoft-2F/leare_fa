import 'package:flutter/material.dart';
import 'package:leare_fa/pages/chat_page.dart';
import 'package:leare_fa/utils/chat/utils_chat.dart';
import 'dart:math' as math;
import '../../models/chat/chat_response.dart';

class ChatCard extends StatelessWidget {
  final ChatModel chat;

  const ChatCard({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        child: ListTile(
          leading: chat.picture != "n/a"
              ? CircleAvatar(
                  backgroundImage: NetworkImage(chat.picture as String))
              : CircleAvatar(
                  backgroundColor:
                      Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                          .withOpacity(1.0),
                  radius: 30,
                  child: Text(getImageLetters(chat)),
                ),
          title: Row(
            children: [
              Text(chat.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ))
            ],
          ),
          subtitle: Row(
            children: [
              const Icon(Icons.done_all),
              Text(chat.last_message?.content != null
                  ? (chat.last_message!.content)
                  : ""),
            ],
          ),
          trailing: Text(getDate(chat)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatPage(),
                settings: RouteSettings(
                  arguments: chat,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
