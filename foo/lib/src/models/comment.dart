// lib/src/models/comment.dart

class Comment {
  final int userId;
  final String text;
  final DateTime date;

  Comment({
    required this.userId,
    required this.text,
    required this.date,
  });

  // Вспомогательная функция для безопасного парсинга int
  // Можно даже вынести ее в отдельный файл с утилитами, если она используется в нескольких местах
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }


  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      // Применяем тот же безопасный парсинг здесь
      userId: _parseInt(json['user_id']),
      text: json['text'] ?? '',
      date: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}