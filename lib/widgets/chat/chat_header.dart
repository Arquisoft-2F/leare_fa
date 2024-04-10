import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:leare_fa/utils/graphql_chat.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

class ChatHeader extends StatefulWidget implements PreferredSizeWidget {
  ChatHeader({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  State<ChatHeader> createState() => ChatHeaderState();
}

class ChatHeaderState extends State<ChatHeader> {
  final GraphQLChat _graphQLChat = GraphQLChat();
  late Chat chat;

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  void _loadInfo() async {
    // Chat chats = _graphQLChat.getChat();
    // setState(() {
    //   chat = chats;
    // });
  }

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
      title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              backgroundColor: Colors.yellow,
              // backgroundImage: NetworkImage(userAvatarUrl),
              child: Text('EB'),
            ),
            Text(overflow: TextOverflow.fade, softWrap: false, 'EstebanQuito')
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
