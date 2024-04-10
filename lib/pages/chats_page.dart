import 'package:flutter/material.dart';
import 'package:leare_fa/models/chat/chat_response.dart';
import 'package:leare_fa/utils/graphql_chat.dart';
import 'package:leare_fa/widgets/chat/chat_card.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => ChatsPageState();
}

class ChatsPageState extends State<ChatsPage> {
  List<ResponseChatModel>? chats;
  final GraphQLChat _graphQLChat = GraphQLChat();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() async {
    print("AAAAA");
    chats = null;
    chats = await _graphQLChat.getMyChats();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(overflow: TextOverflow.fade, softWrap: false, 'Tus chats')
              ]),
          actions: const [
            SizedBox(
              width: 40,
            )
          ],
          backgroundColor: const Color.fromRGBO(238, 241, 250, 1),
        ),
        body: SafeArea(
          child: chats == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : chats!.isEmpty
                  ? const Center(child: Text('No perteneces a ningún chat'))
                  : Expanded(
                      child: ListView.builder(
                          itemCount: chats!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ChatCard(chat: chats![index].chat);
                          })),
        ));
  }
}
