import 'package:leare_fa/models/chat/chat_message.dart';

class Chat {
  final String id;
  final String name;
  final Message? last_message;
  final String? picture;
  final DateTime? creation;

  Chat(
      {required this.id,
      required this.name,
      this.last_message,
      this.picture,
      this.creation});

  static Chat fromMap({required Map map}) {
    if (map['last_message'] != null) {
      Message mess = Message.fromMap(map: map['last_message']);
      try {
        return Chat(
            id: map['id'],
            name: map['chat_name'],
            picture: map['picture_id'],
            last_message: mess,
            creation: DateTime.parse(map['created_at']));
      } catch (error) {
        return Chat(
          id: map['id'],
          name: map['chat_name'],
          picture: map['picture_id'],
          last_message: mess,
        );
      }
    } else {
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
}

class ResponseChatModel {
  final String id;
  final String nickname;
  final Chat chat;

  ResponseChatModel(
      {required this.id, required this.nickname, required this.chat});

  static ResponseChatModel fromMap({required Map map}) {
    Chat newChat = Chat.fromMap(map: map['chat']);
    return ResponseChatModel(
        id: map['user_id'], nickname: map['user_nickname'], chat: newChat);
  }
}
