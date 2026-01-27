import 'package:flutter/material.dart';
import 'package:foo/src/routes/app_routes.dart';
import 'package:foo/src/themes/theme.dart';
import 'package:foo/src/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? errorMessage;
  bool _isLoading = false; // Добавили флаг загрузки

  void _register() async {
    // Сброс ошибок перед новой попыткой
    setState(() {
      errorMessage = null;
    });

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    // Простая валидация
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = "Заполните все поля";
      });
      return;
    }

    if (password != confirm) {
      setState(() {
        errorMessage = "Пароли не совпадают";
      });
      return;
    }

    // Начинаем загрузку
    setState(() {
      _isLoading = true;
    });

    // Создаем сервис (без аргументов, он сам возьмет интерсептор из ApiClient)
    final authService = AuthService();
    
    final success = await authService.register(
      name: name,
      email: email,
      password: password,
    );

    // Проверяем mounted перед использованием контекста после асинхронной операции
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Регистрация успешна! Теперь войдите.")),
      );
      // Переходим на страницу логина, убирая страницу регистрации из стека
      Navigator.pushReplacementNamed(context, AppRoutes.auth);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ошибка регистрации. Возможно, email или имя заняты."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Добавили AppBar для кнопки "Назад"
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                "Регистрация",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 40),

              // Name
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Имя пользователя",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),

              // Email
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Password
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Пароль",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 20),

              // Confirm Password
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Подтвердите пароль",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 10),

              // Error message text
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              
              const SizedBox(height: 10),

              // Register button
              ElevatedButton(
                onPressed: _isLoading ? null : _register, // Блокируем при загрузке
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: AppTheme.dark.primaryColor.withOpacity(0.8),
                ),
                child: _isLoading 
                  ? const SizedBox(
                      height: 20, 
                      width: 20, 
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                    )
                  : Text(
                      "Создать аккаунт",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                    ),
              ),

              const SizedBox(height: 30),

              // Login redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Уже есть аккаунт? "),
                  TextButton(
                    onPressed: () {
                      // Заменяем текущую страницу на страницу входа
                      Navigator.pushReplacementNamed(context, AppRoutes.auth);
                    },
                    child: Text(
                      "Войти",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}