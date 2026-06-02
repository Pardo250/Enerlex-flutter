import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'screens/main_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://gmebzrctmdnpmesiabzy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdtZWJ6cmN0bWRucG1lc2lhYnp5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAzMTM2MTgsImV4cCI6MjA5NTg4OTYxOH0.QE70ERWDYluSmnuOw88VcweE9gw2arDpqN1-0dL10e0',
  );

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
  }

  @override
  Widget build(BuildContext context) {
    // Si hay sesión activa ir directo al home
    final session = Supabase.instance.client.auth.currentSession;

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
      ),
      home: session != null ? const MainScaffold() : const LoginScreen(),
    );
  }
}