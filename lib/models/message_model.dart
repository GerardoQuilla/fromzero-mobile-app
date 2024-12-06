class Message {
  int id;
  String senderId;
  String content;
  int chatId;
  DateTime createdAt;

  Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.chatId,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['senderId'],
      content: json['content'],
      chatId: json['chatId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}