import 'package:flutter/material.dart';
import 'package:foo/src/routes/app_routes.dart';
import 'package:foo/src/services/auth_service.dart';
import 'package:foo/src/services/product_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final ProductService _productService = ProductService();
  bool _isLoading = true;
  bool _isAuth = false;
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final isAuth = await AuthService.isAuthenticated();
    setState(() => _isAuth = isAuth);

    if (!isAuth) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final data = await _productService.getHistory();
      setState(() {
        _history = data;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_isAuth) {
      return Center(
        child: Text(
          "Вы должны авторизоваться, чтобы получить доступ к истории",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    if (_history.isEmpty) {
      return Center(
        child: Text(
          "У вас ничего нету",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return Scaffold(
      body: ListView.builder(
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final item = _history[index];
          final imageUrl = _productService.getImageUrl(item['id']);

          return Card(
            margin: EdgeInsets.zero,
            color: const Color(0xFF1C1C1C),
            shape: const Border(
              bottom: BorderSide(color: Color(0xFF2E2E2E), width: 0.7),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: Image.network(imageUrl, width: 60, fit: BoxFit.cover),
              title: Text(item['name'] ?? 'Без названия'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_rounded),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.product,
                    arguments: item['id'],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}