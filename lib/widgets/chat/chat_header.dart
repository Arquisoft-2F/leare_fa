import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:leare_fa/models/chat/chat_response.dart';
import 'package:leare_fa/utils/chat/utils_chat.dart';

class ChatHeader extends StatelessWidget implements PreferredSizeWidget {
  final ChatModel? chat;

  const ChatHeader({super.key, this.chat})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.navigate_before),
        tooltip: 'Go back',
        onPressed: () {
          Navigator.pushNamed(context, '/home');
        },
      ),
      title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: chat != null && chat?.picture != "n/a"
              ? CircleAvatar(
                  backgroundImage: NetworkImage(chat!.picture as String))
              : CircleAvatar(
                  backgroundColor:
                      Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                          .withOpacity(1.0),
                  child: Text(getImageLetters(chat!)),
                ),
        ),
        Text(overflow: TextOverflow.fade, softWrap: false, chat!.name)
      ]),
      actions: [
        IconButton(
          icon: const Icon(Icons.exit_to_app_rounded),
          tooltip: 'Show Snackbar',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('This is a snackbar')));
          },
        ),
      ],
      backgroundColor: const Color.fromRGBO(238, 241, 250, 1),
    );
  }
}
