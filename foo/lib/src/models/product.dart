// lib/src/models/product.dart
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
    required this.comments,
  });

  // Вспомогательная функция для безопасного парсинга
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

      // Используем нашу безопасную функцию для всех числовых полей
      calories: _parseInt(json['calories']),
      fat: _parseInt(json['fat']),
      protein: _parseInt(json['protein']),
      carbs: _parseInt(json['carbs']),
      sugar: _parseInt(json['sugar']),
      fiber: _parseInt(json['fiber']),

      // Для double можно сделать аналогично, если нужно
      rating: (json['rating'] ?? 0.0).toDouble(),
      nutriscore: json['nutriscore'] ?? 'N/A',
      comments: commentsList.map((c) => Comment.fromJson(c)).toList(),
    );
  }
}