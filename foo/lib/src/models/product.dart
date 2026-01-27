import 'package:foo/src/models/comment.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final int calories;
  final int fat;
  final int protein;
  final int carbs;
  final int sugar;
  final int fiber;
  final double rating;
  final String nutriscore;
  final String imageUrl; // <--- 1. Добавляем поле
  final List<Comment> comments;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.calories,
    required this.fat,
    required this.protein,
    required this.carbs,
    required this.sugar,
    required this.fiber,
    required this.rating,
    required this.nutriscore,
    required this.imageUrl, // <--- 2. Добавляем в конструктор
    required this.comments,
  });

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    final commentsList = json['comments'] as List? ?? [];

    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Без названия',
      description: json['description'] ?? 'Нет описания',
      calories: _parseInt(json['calories']),
      fat: _parseInt(json['fat']),
      protein: _parseInt(json['protein']),
      carbs: _parseInt(json['carbs']),
      sugar: _parseInt(json['sugar']),
      fiber: _parseInt(json['fiber']),
      rating: (json['rating'] ?? 0.0).toDouble(),
      nutriscore: json['nutriscore'] ?? 'N/A',
      // <--- 3. Мапим из JSON (бэкенд отправляет snake_case)
      imageUrl: json['image_url'] ?? '', 
      comments: commentsList.map((c) => Comment.fromJson(c)).toList(),
    );
  }
}