import 'package:flutter/material.dart';
import 'package:foo/src/pages/analyticspage/analytics_page.dart';
import 'package:foo/src/pages/historypage/history_page.dart';
import 'package:foo/src/pages/homepage/home_page.dart';
import 'package:foo/src/themes/theme.dart';
import 'package:foo/src/routes/app_routes.dart';
import 'package:foo/src/routes/router.dart';
import 'package:foo/src/widgets/appBar/app_searching_bar.dart';
import 'package:foo/src/widgets/navigation/app_nagivation_bar.dart'; 

// Глобальный ValueNotifier для темы (простой способ менять тему без провайдеров)
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 1; // Главная страница по центру
  final TextEditingController _controller = TextEditingController();

  final List<Widget> _pages = [
    const HistoryPage(),
    const HomePage(),
    const AnalyticsPage(), // Добавлена страница аналитики
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Foo',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode, // Используем значение из нотификатора
          // Scaffold нужен только для основных табов.
          // Для Auth/Reg/Product мы используем отдельные экраны через роутер.
          home: Scaffold(
            appBar: _currentIndex != 1 ? null : AppSearchingBar(controller: _controller), 
            // Показываем поиск только на главной (или везде, как хочешь. Сейчас скрыл для истории/аналитики для чистоты)
            body: IndexedStack( // Сохраняет состояние страниц при переключении
              index: _currentIndex,
              children: _pages,
            ),
            bottomNavigationBar: AppBottomNav(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          initialRoute: AppRoutes.base,
          onGenerateRoute: AppRouter.generateRoute,
        );
      },
    );
  }
}