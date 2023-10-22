import 'package:flutter/material.dart';
import 'package:win_app_fyp/screens/home_screen.dart';
import 'package:win_app_fyp/screens/login_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());

      default:
        return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }
}
