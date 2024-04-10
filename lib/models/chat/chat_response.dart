import 'dart:ffi';

class Chat {
  final String id;
  final String name;
  final String? picture;
  final DateTime? creation;

  Chat({required this.id, required this.name, this.picture, this.creation});

  static Chat fromMap({required Map map}) {
    try {
      return Chat(
          id: map['id'],
          name: map['chat_name'],
          picture: map['picture_id'],
          creation: DateTime.parse(map['created_at']));
    } catch (error) {
      return Chat(
          id: map['id'], name: map['chat_name'], picture: map['picture_id']);
    }
  }
}

class ResponseChatModel {
  final String id;
  final String nickname;
  final Chat? chat;

  ResponseChatModel({required this.id, required this.nickname, this.chat});

  static ResponseChatModel fromMap({required Map map}) {
    Chat newChat;
    try {
      newChat = Chat(
          id: map['id'],
          name: map['chat_name'],
          picture: map['picture_id'],
          creation: DateTime.parse(map['created_at']));
    } catch (error) {
      newChat = Chat(
          id: map['id'], name: map['chat_name'], picture: map['picture_id']);
    }
    return ResponseChatModel(
        id: map['user_id'], nickname: map['user_nickname'], chat: newChat);
  }
}
