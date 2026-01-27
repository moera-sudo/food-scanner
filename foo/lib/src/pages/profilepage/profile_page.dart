import 'package:flutter/material.dart';
import 'package:foo/app.dart'; // Импортируем, чтобы получить themeNotifier
import 'package:foo/src/services/auth_service.dart';
import 'package:foo/src/routes/app_routes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Профиль")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Настройки", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            
            // Тема
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (ctx, currentMode, _) {
                return ListTile(
                  leading: const Icon(Icons.brightness_6),
                  title: const Text("Тема оформления"),
                  subtitle: Text(currentMode == ThemeMode.dark ? "Темная" : "Светлая"),
                  trailing: Switch(
                    value: currentMode == ThemeMode.dark,
                    onChanged: (isDark) {
                      themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
                      // TODO: Можно сохранить выбор в SharedPrefs или отправить на бэк
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                );
              },
            ),
            
            const Divider(),
            const SizedBox(height: 10),
            Text("Аккаунт", style: Theme.of(context).textTheme.headlineSmall),
            
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Выйти", style: TextStyle(color: Colors.red)),
              onTap: () async {
                await AuthService.logout();
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.welcome, (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}