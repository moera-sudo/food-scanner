import 'package:flutter/material.dart';
import 'package:foo/src/pages/profilepage/profile_page.dart';
import 'package:foo/src/pages/welcomepage/welcome_page.dart';
import 'package:foo/src/pages/undefinedpage/not_ready_page.dart';
import 'package:foo/src/routes/app_routes.dart';
import 'package:foo/src/pages/regpage/reg_page.dart';
import 'package:foo/src/pages/authpage/auth_page.dart';
import 'package:foo/src/pages/goodspage/product_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      case AppRoutes.reg:
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case AppRoutes.auth:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomePage());

      case AppRoutes.product:
        final productId = settings.arguments as int?;
        if (productId == null) {
          return MaterialPageRoute(
            builder: (_) => const PlaceholderPage(),
          );
        }
        return MaterialPageRoute(
          builder: (_) => ProductPage(productId: productId),
        );

      default:
        return MaterialPageRoute(builder: (_) => const PlaceholderPage());
    }
  }
}
