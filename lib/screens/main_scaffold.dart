import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:enerlex_flutter_project/app_state.dart';
import 'home_screen.dart';
import 'devices_screen.dart';
import 'alerts_screen.dart';
import 'config_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  bool _initialized = false;

  static const Color _cardBg    = Color(0xFF1A1D27);
  static const Color _accent    = Color(0xFF00E5A0);
  static const Color _textMuted = Color(0xFF6B7280);

  final List<Widget> _screens = const [
    HomeScreen(),
    DevicesScreen(),
    AlertsScreen(),
    ConfigScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      // Cargar perfil del usuario
      final perfil = await Supabase.instance.client
          .from('perfiles')
          .select()
          .eq('id', user.id)
          .single();

      AppState().registrar(
        nombre: perfil['nombre'] ?? user.email?.split('@').first ?? '',
        correo: perfil['correo'] ?? user.email ?? '',
        password: '',
      );

      // Cargar dispositivos
      await AppState().cargarDispositivos();
    } catch (e) {
      debugPrint('Error cargando datos: $e');
    }

    if (mounted) setState(() => _initialized = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F1117),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF00E5A0)),
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: _cardBg,
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06), width: 1)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(0, Icons.home_rounded, 'Inicio'),
                _navItem(1, Icons.devices_outlined, 'Dispositivos'),
                _navItem(2, Icons.notifications_outlined, 'Alertas'),
                _navItem(3, Icons.settings_outlined, 'Config'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final bool selected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: selected ? _accent : _textMuted, size: 24),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: selected ? _accent : _textMuted, fontSize: 11, fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}