class Comment {
  final int id;
  final int userId;
  final String username; 
  final String text;
  final DateTime date;

  Comment({
    required this.id,
    required this.userId,
    required this.username,
    required this.text,
    required this.date,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      username: json['username'] ?? 'User', 
      text: json['text'] ?? '',
      date: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}