import 'package:flutter/material.dart';
import 'package:foo/src/pages/historypage/history_page.dart';
import 'package:foo/src/pages/homepage/home_page.dart';
import 'package:foo/src/themes/theme.dart';
import 'package:foo/src/routes/app_routes.dart';
import 'package:foo/src/routes/router.dart';
 
import 'package:foo/src/widgets/appBar/app_searching_bar.dart';
import 'package:foo/src/widgets/navigation/app_nagivation_bar.dart';
import 'package:foo/src/pages/undefinedpage/not_ready_page.dart';
import 'package:foo/src/pages/authpage/auth_page.dart';
import 'package:foo/src/pages/regpage/reg_page.dart';
import 'package:foo/src/pages/welcomepage/welcome_page.dart';

// I'm gonna clear useless imports later

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{

  int _currentIndex = 1;
  final TextEditingController _controller = TextEditingController();

  final List<Widget> _pages = [ // Добавить Const
    HistoryPage(),
    HomePage(),
    PlaceholderPage(),
  ];
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foo',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppSearchingBar(controller: _controller),
        body: _pages[_currentIndex],
        bottomNavigationBar: AppBottomNav(
          currentIndex: _currentIndex,
          onTap: (index){
            setState(() {
              _currentIndex = index;
            });
          }),

      ),
      initialRoute: AppRoutes.base,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
