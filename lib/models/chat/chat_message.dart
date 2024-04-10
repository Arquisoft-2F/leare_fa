class Message {
  final String id;
  final String chat_id;
  final String sender_id;
  final String sender_nickname;
  final String content;
  final DateTime? creation;
  final DateTime? update;

  Message(
      {required this.id,
      required this.chat_id,
      required this.sender_id,
      required this.sender_nickname,
      required this.content,
      this.creation,
      this.update});

  static Message fromMap({required Map map}) {
    try {
      return Message(
          id: map['id'],
          chat_id: map['chat_id'],
          sender_id: map['sender_id'],
          sender_nickname: map['sender_nickname'],
          content: map['content'],
          creation: DateTime.parse(map['created_at']),
          update: DateTime.parse(map['updated_at']));
    } catch (error) {
      return Message(
          id: map['id'],
          chat_id: map['chat_id'],
          sender_id: map['sender_id'],
          sender_nickname: map['sender_nickname'],
          content: map['content']);
    }
  }
}
