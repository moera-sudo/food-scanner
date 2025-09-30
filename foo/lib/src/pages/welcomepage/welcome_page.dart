import 'package:flutter/material.dart';
import 'package:foo/src/routes/app_routes.dart';
import 'package:foo/src/themes/theme.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Логотип
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Foo",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold, fontSize: 40,
                      ),
                ),
                Icon(Icons.lunch_dining_rounded, size: 40, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
              ],
            ),

            const SizedBox(height: 40),

            // Описание
            Text(
              "Foo – ваш помощник при выборе еды.\n"
              "С нами вы можете в один момент понять,\n"
              "насколько хорошо вы собираетесь пообедать.",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 80),

            // Кнопка Войти
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.auth);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: Theme.of(context).cardColor,
                foregroundColor: Colors.white,
              ),
              child: const Text("Войти"),
            ),

            const SizedBox(height: 16),

            // Кнопка Создать аккаунт
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.reg);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text("Создать аккаунт"),
            ),

            const SizedBox(height: 16),

            // Кнопка Продолжить без аккаунта
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/home");
              },
              child: Text(
                "Продолжить без аккаунта",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
