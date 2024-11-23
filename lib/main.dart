import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:baatcheet/services/navigation_service.dart';
import 'package:baatcheet/pages/splash_page.dart';
import 'package:baatcheet/pages/login_page.dart';
import 'package:baatcheet/pages/register_page.dart';
import 'package:baatcheet/pages/home_page.dart';
import 'package:baatcheet/providers/authentication_provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (BuildContext _context) {
            return AuthenticationProvider();
          },
        ),
      ],
      child: MaterialApp(
        title: 'BaatCheet',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            surface: const Color.fromRGBO(
                36, 35, 49, 1.0), // Replaces backgroundColor
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
          '/register': (BuildContext context) => const RegisterPage(),
          '/home': (BuildContext context) => HomePage(),
        },
      ),
    );
  }
}
