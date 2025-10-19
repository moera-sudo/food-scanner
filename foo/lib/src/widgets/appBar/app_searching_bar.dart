import 'package:flutter/material.dart';
import 'package:foo/src/routes/app_routes.dart';
import 'package:foo/src/services/auth_service.dart';
import 'package:foo/src/services/product_service.dart';


class AppSearchingBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;

  const AppSearchingBar({
    super.key,
    required this.controller,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                onSubmitted: (value) async{
                  if (value.trim().isEmpty) return;

                  final service = ProductService();
                  final id = await service.searchProduct(value);

                  if (id != null){
                    Navigator.pushNamed(context, AppRoutes.product, arguments: id);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Продукт не найден"))
                    );
                  }
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Поиск..',
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  filled: true,
                  fillColor: Colors.grey.withValues(alpha: 0.15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // 🔽 вот тут добавляем проверку
          IconButton(
            onPressed: () async {
              final isAuth = await AuthService.isAuthenticated();

              if (!isAuth) {
                // показать диалог
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Требуется вход"),
                    content: const Text("Чтобы открыть профиль, необходимо войти в систему."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Отмена"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // закрыть диалог
                          Navigator.pushNamed(context, AppRoutes.auth); // перейти на страницу входа
                        },
                        child: const Text("Войти"),
                      ),
                    ],
                  ),
                );
              } else {
                Navigator.pushNamed(context, AppRoutes.profile);
              }
            },
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
