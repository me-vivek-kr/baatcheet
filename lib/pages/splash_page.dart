import 'package:flutter/material.dart';
//Packages
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
//Services
import 'package:baatcheet/services/navigation_service.dart';
import 'package:baatcheet/services/media_service.dart';
import 'package:baatcheet/services/cloud_storage_service.dart';
import 'package:baatcheet/services/database_service.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onInitializationComplete;

  const SplashPage({super.key, required this.onInitializationComplete});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1)).then(
      (_) {
        _setup().then(
          (_) => widget.onInitializationComplete(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BaatCheet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          surface:
              const Color.fromRGBO(36, 35, 49, 1.0), // Replaces backgroundColor
        ),
        scaffoldBackgroundColor:
            const Color.fromRGBO(36, 35, 49, 1.0), // Still supported
      ),
      home: Scaffold(
        body: Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage('assets/images/logo.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      await Firebase.initializeApp();
      print("Firebase Initialized Successfully");
    } catch (e) {
      print("Firebase Initialization Failed");
    }
    _registerServices();
  }

  void _registerServices() {
    GetIt.instance.registerSingleton<NavigationService>(NavigationService());
    GetIt.instance.registerSingleton<MediaService>(MediaService());
    GetIt.instance
        .registerSingleton<CloudStorageService>(CloudStorageService());
    GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
  }
}
