import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:win_app_fyp/routes.dart';
import 'package:win_app_fyp/services/auth_service.dart';
import 'package:win_app_fyp/themes/colors.dart';


void main() {
  
  runApp(MyApp());
  doWhenWindowReady(() {
    appWindow.minSize = const Size(400, 600);
    appWindow.maxSize = const Size(400, 600);
    appWindow.size = const Size(400, 600);
  });
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  // This widget is the root of your application.
 final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FutureBuilder<bool>(
        future: _authService.isTokenExpired(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && !snapshot.data!) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Eudaimonia Mobile',
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSwatch().copyWith(
                    primary: AppColors.primaryColor,
                    secondary: AppColors.primaryColor,
                  ),
                  textTheme: ThemeData().textTheme.apply(
                        fontFamily: 'Poppins',
                      ),
                ),
                initialRoute: '/home',
                onGenerateRoute: Routes.generateRoute,
              );
            } else {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Eudaimonia Mobile',
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSwatch().copyWith(
                    primary: AppColors.primaryColor,
                    secondary: AppColors.primaryColor,
                  ),
                  textTheme: ThemeData().textTheme.apply(
                        fontFamily: 'Poppins',
                      ),
                ),
                initialRoute: '/login',
                onGenerateRoute: Routes.generateRoute,
              );
            }
          } else {
            // Show a loading indicator while checking token expiration
            return Container(
              color: Colors.white,

              height: double.infinity,
              width: double.infinity,
              child: LoadingAnimationWidget.fallingDot(
                color: AppColors.primaryColor,
                size: 60,
              ),
            );
          }
        },
      ),
    );
  }
}
