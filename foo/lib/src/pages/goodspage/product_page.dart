import 'package:flutter/material.dart';
import 'package:foo/src/models/product.dart'; // Импортируем нашу новую модель
import 'package:foo/src/services/product_service.dart'; // Импортируем сервис
import 'package:foo/src/widgets/RatingCards/nutri_score_card.dart';
import 'package:foo/src/widgets/RatingCards/rating_card.dart';
import 'package:foo/src/widgets/commentsBar/comments_bar.dart';

// 1. Превращаем в StatefulWidget, чтобы управлять состоянием загрузки
class ProductPage extends StatefulWidget {
  final int productId; // Страница теперь должна знать ID продукта для запроса

  const ProductPage({super.key, required this.productId});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // 2. Создаем переменные для управления асинхронной операцией
  late Future<Product> _productFuture;
  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    // 3. Запускаем загрузку данных при создании экрана
    _productFuture = _loadProduct();
  }

  // Метод для загрузки продукта с сервера
  Future<Product> _loadProduct() async {
    try {
      // Вызываем метод сервиса для получения данных
      final productData = await _productService.getProduct(widget.productId);
      // Преобразуем полученный JSON в наш объект Product
      return Product.fromJson(productData);
    } catch (e) {
      // В случае ошибки, FutureBuilder сможет ее обработать
      throw Exception('Не удалось загрузить продукт: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 4. Используем FutureBuilder для отображения разных состояний
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          // Пока данные грузятся, показываем индикатор загрузки
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Если произошла ошибка, показываем текст ошибки
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }

          // Если данных нет (маловероятно при отсутствии ошибки, но для надежности)
          if (!snapshot.hasData) {
            return const Center(child: Text('Продукт не найден'));
          }

          // Если данные успешно загружены
          final product = snapshot.data!;
          final imageUrl = _productService.getImageUrl(product.id);

          // Возвращаем ваш UI, но с данными из объекта `product`
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  imageUrl, // <-- ДАННЫЕ С СЕРВЕРА
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                     return Container(height: 250, color: Colors.grey.shade800, child: const Icon(Icons.image_not_supported, size: 50));
                  },
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name, // <-- ДАННЫЕ С СЕРВЕРА
                        style: Theme.of(context).textTheme.headlineLarge),
                      const SizedBox(height: 8),
                      Text(
                        product.description, // <-- ДАННЫЕ С СЕРВЕРА
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Nutrition Facts", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Divider(color: Color(0xFF2E2E2E), thickness: 1),
                      const SizedBox(height: 8),
                      // Используем данные из `product`
                      _buildNutritionRow("Calories", product.calories.toString(), "Fat", "${product.fat}g"),
                      const SizedBox(height: 8),
                      const Divider(color: Color(0xFF2E2E2E), thickness: 1),
                      const SizedBox(height: 8),
                      _buildNutritionRow("Protein", "${product.protein}g", "Carbs", "${product.carbs}g"),
                      const SizedBox(height: 8),
                      const Divider(color: Color(0xFF2E2E2E), thickness: 1),
                      const SizedBox(height: 8),
                      _buildNutritionRow("Sugar", "${product.sugar}g", "Fiber", "${product.fiber}g"),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(children: [
                        const Text("Рейтинг"),
                        const SizedBox(height: 10),
                        RatingCard(value: product.rating), // <-- ДАННЫЕ С СЕРВЕРА
                      ]),
                      const SizedBox(width: 60),
                      Column(children: [
                        const Text("Nutri-Score"),
                        const SizedBox(height: 10),
                        NutriScoreCard(grade: product.nutriscore), // <-- ДАННЫЕ С СЕРВЕРА
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CommentsSection(comments: product.comments), // <-- ДАННЫЕ С СЕРВЕРА
                const SizedBox(height: 10)
              ],
            ),
          );
        },
      ),
    );
  }

  // Вспомогательный виджет, чтобы не дублировать код
  Widget _buildNutritionRow(String title1, String value1, String title2, String value2) {
    return Row(
      children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title1, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value1, style: const TextStyle(fontSize: 16)),
        ])),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title2, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value2, style: const TextStyle(fontSize: 16)),
        ])),
      ],
    );
  }
}