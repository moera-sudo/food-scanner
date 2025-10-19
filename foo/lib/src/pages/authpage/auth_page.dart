import 'package:flutter/material.dart';
import 'package:foo/src/core/config/interceptors/auth_interceptor.dart';
import 'package:foo/src/routes/app_routes.dart';
import 'package:foo/src/themes/theme.dart';
import 'package:foo/src/services/auth_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    final authInterceptor = AuthInterceptor();
    final authService = AuthService(authInterceptor);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Вход",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge
            ),
            const SizedBox(height: 40),

            // Email / Username
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email или Username",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
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
            SizedBox(height: 30),


            // Login button
            ElevatedButton(
              onPressed: () async {
                final success = await authService.login(
                  loginInput: emailController.text.trim(),
                  password: passwordController.text.trim(),
                );

                if (success) {
                  Navigator.pushReplacementNamed(context, AppRoutes.base);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Ошибка входа")),
                  );
                }
              },

              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: AppTheme.dark.primaryColor.withValues(alpha: 0.5) 
              ),
              child: Text(
                "Войти",
                style: Theme.of(context).textTheme.bodyLarge),
            ),

            const SizedBox(height: 30),
            
            // Register
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Нет аккаунта? "),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context, AppRoutes.reg);
                  },
                  child: Text(
                    "Создать",
                    style: Theme.of(context).textTheme.labelLarge),
                )
              ]
            )
          ]
        )
                
              
      ),      
    );
  }
}
