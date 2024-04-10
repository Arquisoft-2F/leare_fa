import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../models/chat/chat_response.dart';

class ChatCard extends StatelessWidget {
  final Chat chat;

  const ChatCard({super.key, required this.chat});

  String getImageLetters() {
    String letters = "";
    final splitted = chat.name.split(' ');
    for (String word in splitted) {
      letters += word[0].toUpperCase();
    }
    return letters;
  }

  String convertDate(DateTime? x) {
    String res = "";
    if (x?.year != null) {
      res += x!.year.toString();
      res += "-";
    }
    if (x?.month != null) {
      res += x!.month.toString();
      res += "-";
    }
    if (x?.day != null) {
      res += x!.day.toString();
      res += "-";
    }
    return res.substring(0, res.length - 1);
  }

  String getDate() {
    if (chat.last_message?.update != null) {
      return convertDate(chat.last_message!.update);
    } else if (chat.creation != null) {
      return convertDate(chat.creation);
    }
    return "";
  }

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
                  child: Text(getImageLetters()),
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
          trailing: Text(getDate()),
        ),
      ),
    );
  }
}
