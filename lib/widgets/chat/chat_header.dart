import 'dart:convert';
import 'dart:math' as math;

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
import 'package:leare_fa/models/chat/chat_response.dart';
import 'package:leare_fa/utils/chat/graphql_chat.dart';
import 'package:leare_fa/utils/chat/utils_chat.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

class ChatHeader extends StatelessWidget implements PreferredSizeWidget {
  final ChatModel? chat;

  ChatHeader({Key? key, this.chat})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

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
          padding: EdgeInsets.all(16.0),
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
