import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:baatcheet/services/navigation_service.dart';
import 'package:baatcheet/pages/splash_page.dart';
import 'package:baatcheet/pages/login_page.dart';

void main() async {
  runApp(
    SplashPage(onInitializationComplete: () {
      runApp(
        const MyApp(),
      );
    }),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BaatCheet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          surface:
              const Color.fromRGBO(36, 35, 49, 1.0), // Replaces backgroundColor
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromRGBO(30, 29, 37, 1.0),
        ),
      ),
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext context) => const LoginPage(),
      },
    );
  }
}
