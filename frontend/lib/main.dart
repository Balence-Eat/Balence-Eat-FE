import 'package:flutter/material.dart';
import 'package:frontend/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BalanceEatApp());
}

class BalanceEatApp extends StatefulWidget {
  @override
  State<BalanceEatApp> createState() => _BalanceEatAppState();
}

class _BalanceEatAppState extends State<BalanceEatApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: '밸런스잇',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightGreen,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.lightGreen[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.lightGreen,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.lightGreen,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightGreen,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
