import 'package:flutter/material.dart';
import 'package:foo/src/models/product.dart';
import 'package:foo/src/services/product_service.dart';
import 'package:foo/src/widgets/RatingCards/nutri_score_card.dart';
import 'package:foo/src/widgets/RatingCards/rating_card.dart';
import 'package:foo/src/widgets/commentsBar/comments_bar.dart';

class ProductPage extends StatefulWidget {
  final int productId;

  const ProductPage({super.key, required this.productId});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<Product> _productFuture;
  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    _refreshProduct();
  }

  void _refreshProduct() {
    setState(() {
      _productFuture = _loadProduct();
    });
  }

  Future<Product> _loadProduct() async {
    final productData = await _productService.getProduct(widget.productId);
    return Product.fromJson(productData);
  }
// /-|\|/-\  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Продукт не найден'));
          }

          final product = snapshot.data!;
          // Умное получение URL: если там путь uploads/, сервис сам подставит домен
          final imageUrl = _productService.getImageUrl(product.imageUrl); 
          // (Если в Dart модели нет поля image_url, добавь его в Product.fromJson: image_url: json['image_url'])

          return CustomScrollView( // Используем Slivers для красивого скролла и кнопки назад
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                leading: Container( // Кнопка назад в кружочке для контраста
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    imageUrl, // Используем url из сервиса
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, style: Theme.of(context).textTheme.headlineLarge),
                      const SizedBox(height: 8),
                      Text(product.description, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 24),
                      
                      // Таблица нутриентов
                      _buildNutritionTable(product),
                      
                      const SizedBox(height: 24),
                      
                      // Рейтинги
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _RatingColumn("Рейтинг", RatingCard(value: product.rating)),
                          _RatingColumn("Nutri-Score", NutriScoreCard(grade: product.nutriscore)),
                        ],
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Комментарии
                      CommentsSection(
                        comments: product.comments,
                        productId: product.id,
                        onCommentPosted: _refreshProduct, // Перезагружаем страницу после отправки
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNutritionTable(Product p) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text("Пищевая ценность (на 100г)", style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          _nutriRow("Калории", "${p.calories} ккал"),
          _nutriRow("Жиры", "${p.fat} г"),
          _nutriRow("Белки", "${p.protein} г"),
          _nutriRow("Углеводы", "${p.carbs} г"),
          _nutriRow("Сахар", "${p.sugar} г"),
          _nutriRow("Клетчатка", "${p.fiber} г"),
        ],
      ),
    );
  }

  Widget _nutriRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: const TextStyle(color: Colors.grey)), Text(value)],
      ),
    );
  }
}

class _RatingColumn extends StatelessWidget {
  final String label;
  final Widget child;
  const _RatingColumn(this.label, this.child);
  @override
  Widget build(BuildContext context) {
    return Column(children: [Text(label, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 8), child]);
  }
}