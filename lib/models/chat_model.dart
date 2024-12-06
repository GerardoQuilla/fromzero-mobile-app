class Chat {
  int id;
  String developer;
  String company;
  DateTime createdAt;

  Chat({
    required this.id,
    required this.developer,
    required this.company,
    required this.createdAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      developer: json['developer'],
      company: json['company'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}