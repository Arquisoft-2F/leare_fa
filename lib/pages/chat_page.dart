import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:leare_fa/models/chat/chat_message.dart';
import 'package:leare_fa/models/chat/chat_response.dart';
import 'package:leare_fa/utils/chat/graphql_chat.dart';

import '../widgets/chat/chat_header.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  late SharedPreferences prefs;
  bool isLoaing = true;
  ChatModel? chat;
  String? user_id;
  String? nickname;
  List<types.Message> _messages = [];
  final GraphQLChat _graphQLChat = GraphQLChat();
  List<types.User> _users = [];
  types.User _user = const types.User(id: "");
  WebSocketChannel? _channel;
  Map<String, types.User> users = <String, types.User>{};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (isLoaing) {
        chat = ModalRoute.of(context)!.settings.arguments as ChatModel;
        if (chat != null) {
          configureWS();
        }
        isLoaing = false;
      }
    });
    _loadMessages();
  }

  void configureWS() {
    if (chat != null) {
      print('Connecting to WebSocket...1');
      try {
        print('Connecting to WebSocket...2');
        _channel = WebSocketChannel.connect(
          Uri.parse('wss://35.215.45.12/ws/${chat!.id}'),
        );
        print('Connecting to WebSocket...3');
        _loadMessages();
        _channel?.stream.listen(
          (data) {
            print('Received data from WebSocket: $data');
            // Handle incoming messages
            _addMessageList(data);
          },
          onError: (error) {
            print('WebSocket error: $error');
            String disconnect = (jsonEncode({
              "type": "user_connected",
              "user_id": _user.id,
              "user_nickname": _user.firstName,
            }));
            _channel!.sink.add(disconnect);
            _channel?.sink.close();
            // Handle WebSocket errors
          },
          onDone: () {
            print('WebSocket connection closed');
            // Handle WebSocket connection closed
          },
        );
      } catch (e) {
        print('Error connecting to WebSocket: $e');
        // Handle connection errors
      }
    }
  }

  void _loadMessages() async {
    try {
      prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> jwtDecodedToken =
          JwtDecoder.decode(prefs.getString('token') as String);
      String userID = jwtDecodedToken['UserID'];
      String nickname = jwtDecodedToken['Username'];
      _user = types.User(id: userID, firstName: nickname);
      users[userID] = _user;
    } catch (error) {
      // Handle error if fetching data fails
      print("Error fetching user data: $error");
    }
    List<MessageModel> mess = [];
    if (chat != null) {
      mess = await _graphQLChat.getMessages(chat!.id);
    }
    List<types.User> newUsers = [];
    for (MessageModel m in mess) {
      types.User newUser = types.User(
        id: m.sender_id,
        firstName: m.sender_nickname,
      );
      if (users[m.sender_id] == null) {
        newUsers.add(newUser);
        users[m.sender_id] = newUser;
      }
    }
    List<types.Message> messagesnew = [];
    for (MessageModel m in mess) {
      if (users[m.sender_id] != null) {
        messagesnew.add(types.TextMessage(
            author: users[m.sender_id]!,
            id: m.id,
            text: m.content,
            createdAt: m.creation?.millisecondsSinceEpoch,
            updatedAt: m.update?.millisecondsSinceEpoch));
      }
    }
    _messages = messagesnew.reversed.toList();
    _users = newUsers;
    setState(() {});
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().toUtc().millisecondsSinceEpoch,
      id: "id",
      text: message.text,
    );

    _addMessage(textMessage);
  }

  void _addMessageList(String data) {
    print('data');
    print(data);
    var s = json.decode(data);
    if (s['type'] == "message_sent") {
      if (users[s['sender_id']] != null) {
        _messages.insert(
            0,
            types.TextMessage(
                id: s['id'],
                author: users[s['sender_id']]!,
                text: s['content'],
                createdAt:
                    DateTime.parse(s['created_at']).millisecondsSinceEpoch));
        print(_messages[0]);
        setState(() {});
      } else {
        users[s['sender_id']] =
            types.User(id: s['sender_id'], firstName: s['sender_nickname']);
        _messages.insert(
            0,
            types.TextMessage(
                id: s['id'],
                author: users[s['sender_id']]!,
                text: s['content'],
                createdAt:
                    DateTime.parse(s['created_at']).millisecondsSinceEpoch));
        print(_messages[0]);
        setState(() {});
      }
    } else if (s['type'] == "message_edited") {
      print('edito');
      print(s);
      for (int i = 0; i < _messages.length; i++) {
        types.TextMessage? m = _messages[i] as types.TextMessage?;
        if (m?.id == s['id']) {
          print(s['id']);
          print(m!.author);
          print(s['content']);
          _messages[i] = types.TextMessage(
              id: s['id'],
              author: users[s['sender_id']]!,
              text: s['content'],
              createdAt:
                  DateTime.parse(s['created_at']).millisecondsSinceEpoch);
          break;
        }
      }
    } else if (s['type'] == "message_deleted") {
      print('elimino');
      for (int i = 0; i < _messages.length; i++) {
        types.TextMessage? m = _messages[i] as types.TextMessage?;
        if (m?.id == s['id']) {
          setState(() {
            _messages.removeAt(i);
          });
          break;
        }
      }
    }
  }

  void _editMessage(types.TextMessage data, String content) {
    String edited = (jsonEncode({
      "type": "message_edited",
      "message_id": data.id,
      "content": content,
    }));
    _channel!.sink.add(edited);
    if (data.author == _user) {
      for (int i = 0; i < _messages.length; i++) {
        types.TextMessage? m = _messages[i] as types.TextMessage?;
        if (m?.id == data.id) {
          setState(() {
            _messages[i] = types.TextMessage(
                id: m!.id,
                author: m.author,
                text: content,
                createdAt: data.createdAt);
          });
          break;
        }
      }
    }
  }

  void _deleteMessage(types.TextMessage data) {
    String deleted =
        (jsonEncode({"type": "message_deleted", "message_id": data.id}));
    _channel!.sink.add(deleted);
    if (data.author == _user) {
      for (int i = 0; i < _messages.length; i++) {
        types.TextMessage? m = _messages[i] as types.TextMessage?;
        if (m?.id == data.id) {
          setState(() {
            _messages.removeAt(i);
          });
          break;
        }
      }
    }
  }

  void _addMessage(types.Message message) {
    String sended = (jsonEncode({
      "type": "message_sent",
      "user_id": message.author.id,
      "user_nickname": message.author.firstName,
      "content": json.decode(jsonEncode(message.toJson()))['text'],
      "created_at": DateTime.now().toString()
    }));
    _channel!.sink.add(sended);
  }

  @override
  Widget build(BuildContext context) {
    if (chat == null || _user.id == "" || _channel == null || isLoaing) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: ChatHeader(
        chat: chat,
      ),
      body: Chat(
        messages: _messages,
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: _handleSendPressed,
        showUserAvatars: true,
        showUserNames: true,
        user: _user,
        bubbleBuilder: _bubbleBuilder,
        theme: const DefaultChatTheme(
          inputBackgroundColor: Color.fromRGBO(238, 241, 250, 1),
          inputTextColor: Colors.black,
          primaryColor: Colors.blue,
          seenIcon: Text(
            'read',
            style: TextStyle(
              fontSize: 10.0,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, types.TextMessage message) {
    final editMessage = TextEditingController(text: message.text);
    print(message.text);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar mensaje'),
          content: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
            ),
            controller: editMessage,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Editar'),
              onPressed: () {
                _editMessage(message, editMessage.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _bubbleBuilder(
    Widget child, {
    required message,
    required nextMessageInGroup,
  }) =>
      Row(
        mainAxisAlignment: _user.id != message.author.id
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: (message as types.TextMessage).author == _user
                ? [
                    PopupMenuButton(
                      itemBuilder: (BuildContext contect) {
                        return [
                          const PopupMenuItem(
                              value: "edit",
                              child: Row(
                                children: [Icon(Icons.edit), Text("Editar")],
                              )),
                          const PopupMenuItem(
                              value: "delete",
                              child: Row(
                                children: [
                                  Icon(Icons.delete),
                                  Text("Eliminar")
                                ],
                              )),
                        ];
                      },
                      elevation: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      onSelected: (value) {
                        switch (value) {
                          case "edit":
                            _dialogBuilder(
                                context, message as types.TextMessage);
                            break;
                          case "delete":
                            _deleteMessage(message as types.TextMessage);
                            break;
                          default:
                            {
                              print("Invalid choice");
                            }
                            break;
                        }
                      },
                    )
                  ]
                : [],
          ),
          Expanded(
              child: Bubble(
            color: _user.id != message.author.id ||
                    message.type == types.MessageType.image
                ? const Color(0xfff5f5f7)
                : const Color(0xff6f61e8),
            margin: nextMessageInGroup
                ? const BubbleEdges.symmetric(horizontal: 6)
                : null,
            nip: nextMessageInGroup
                ? BubbleNip.no
                : _user.id != message.author.id
                    ? BubbleNip.leftBottom
                    : BubbleNip.rightBottom,
            child: child,
          ))
        ],
      );

  @override
  void dispose() {
    String disconnect = (jsonEncode({
      "type": "user_connected",
      "user_id": _user.id,
      "user_nickname": _user.firstName,
    }));
    _channel!.sink.add(disconnect);
    _channel?.sink.close();
    super.dispose();
  }
}
