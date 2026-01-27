import 'package:flutter/material.dart';
import 'package:foo/src/routes/app_routes.dart';
import 'package:foo/src/services/product_service.dart';
import 'package:foo/src/widgets/photoSearchBtn/glass_button.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  final ProductService _productService = ProductService();
  bool _isAnalyzing = false;

  Future<void> _takePhoto() async {
    try {
      // 1. Открываем камеру
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera, // Можно сменить на gallery
        imageQuality: 80, // Оптимизация размера
      );

      if (photo == null) return; // Пользователь отменил

      setState(() => _isAnalyzing = true);

      // 2. Отправляем на бэк
      final productId = await _productService.searchByPhoto(photo);

      if (!mounted) return;

      setState(() => _isAnalyzing = false);

      if (productId != null) {
        // 3. Переходим на страницу продукта
        Navigator.pushNamed(context, AppRoutes.product, arguments: productId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Продукт не распознан 😔")),
        );
      }
    } catch (e) {
      setState(() => _isAnalyzing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Убираем AppBar здесь, так как он есть в AppSearchingBar в app.dart
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Сфотографируй еду",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                GlassButton(
                  onPressed: _takePhoto,
                  icon: Icons.camera_alt_rounded,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Нажми для анализа",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          if (_isAnalyzing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFFEF8235)),
                    SizedBox(height: 20),
                    Text("Анализируем изображение...", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}