import 'package:flutter/material.dart';
import 'package:foo/src/routes/app_routes.dart';
import 'package:foo/src/themes/theme.dart';
import 'package:foo/src/services/auth_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    // Создаем сервис без аргументов (он сам всё возьмет из ApiClient)
    final authService = AuthService();

    return Scaffold(
      // ИСПРАВЛЕНИЕ: Добавляем AppBar с кнопкой назад
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent, // Прозрачный AppBar
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView( // Добавил скролл на случай маленьких экранов
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20), // Отступ сверху
              Text(
                "Вход",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 40),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email или Username",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Пароль",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () async {
                  final success = await authService.login(
                    loginInput: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );

                  if (success) {
                    // Используем pushNamedAndRemoveUntil, чтобы сбросить навигацию на Home
                    Navigator.pushNamedAndRemoveUntil(
                        context, AppRoutes.base, (route) => false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Ошибка входа. Проверьте данные.")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: AppTheme.dark.primaryColor.withOpacity(0.8),
                ),
                child: Text(
                  "Войти",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Нет аккаунта? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.reg);
                    },
                    child: Text(
                      "Создать",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}