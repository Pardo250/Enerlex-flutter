import 'package:flutter/material.dart';
import 'package:enerlex_flutter_project/app_state.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const EnerLexApp());
}

class EnerLexApp extends StatefulWidget {
  const EnerLexApp({super.key});

  static _EnerLexAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_EnerLexAppState>();

  @override
  State<EnerLexApp> createState() => _EnerLexAppState();
}

class _EnerLexAppState extends State<EnerLexApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
    AppState().setDarkMode(mode == ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EnerLex',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F1117),
        fontFamily: 'Roboto',
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF2F4F8),
        fontFamily: 'Roboto',
        cardColor: const Color(0xFFFFFFFF),
      ),
      home: const LoginScreen(),
    );
  }
}