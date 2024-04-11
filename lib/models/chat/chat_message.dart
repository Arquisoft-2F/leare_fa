class MessageModel {
  final String id;
  final String sender_id;
  final String sender_nickname;
  final String content;
  final DateTime? creation;
  final DateTime? update;

  MessageModel(
      {required this.id,
      required this.sender_id,
      required this.sender_nickname,
      required this.content,
      this.creation,
      this.update});

  static MessageModel fromMap({required Map map}) {
    try {
      return MessageModel(
          id: map['id'],
          sender_id: map['sender_id'],
          sender_nickname: map['sender_nickname'],
          content: map['content'],
          creation: DateTime.parse(map['created_at']),
          update: DateTime.parse(map['updated_at']));
    } catch (error) {
      return MessageModel(
          id: map['id'],
          sender_id: map['sender_id'],
          sender_nickname: map['sender_nickname'],
          content: map['content']);
    }
  }
}
