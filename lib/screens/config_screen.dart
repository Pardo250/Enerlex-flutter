import 'package:flutter/material.dart';
import 'package:enerlex_flutter_project/app_state.dart';
import 'package:enerlex_flutter_project/main.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});
  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  bool _notificationsOn = true;

  static const Color _accent    = Color(0xFF00E5A0);
  static const Color _redColor  = Color(0xFFEF4444);

  @override
  void initState() {
    super.initState();
    AppState().addListener(_onStateChanged);
  }

  @override
  void dispose() {
    AppState().removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() => setState(() {});

  void _cerrarSesion() {
    AppState().cerrarSesion();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AppState();
    final isDark = user.isDarkMode;

    // Colores adaptativos al tema
    final bg     = isDark ? const Color(0xFF0F1117) : const Color(0xFFF2F4F8);
    final cardBg = isDark ? const Color(0xFF1A1D27) : const Color(0xFFFFFFFF);
    final textPrimary = isDark ? const Color(0xFFE5E7EB) : const Color(0xFF111827);
    final textMuted   = isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 20),
            _buildProfileCard(context, user, cardBg, textPrimary, textMuted),
            const SizedBox(height: 20),
            _buildSettingsCard(user, cardBg, textPrimary, textMuted, isDark),
            const SizedBox(height: 20),
            _buildLogoutButton(cardBg),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, AppState user, Color cardBg, Color textPrimary, Color textMuted) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      ).then((_) => setState(() {})),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: _accent,
                  child: Text(
                    user.inicial,
                    style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                ),
                Positioned(
                  bottom: 0, right: 0,
                  child: Container(
                    width: 20, height: 20,
                    decoration: BoxDecoration(
                      color: cardBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: cardBg, width: 1.5),
                    ),
                    child: Icon(Icons.camera_alt, size: 11, color: textMuted),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.nombre.isNotEmpty ? user.nombre : 'Usuario',
                    style: TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.correo.isNotEmpty ? user.correo : '',
                    style: TextStyle(color: textMuted, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  const Text('Plan Hogar Premium', style: TextStyle(color: _accent, fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(AppState user, Color cardBg, Color textPrimary, Color textMuted, bool isDark) {
    return Container(
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _buildNavItem('Límites de consumo', 'Personaliza umbrales', textPrimary, textMuted, () {}),
          _buildDivider(isDark),
          _buildToggleItem('Notificaciones', 'Push, Email, SMS', textPrimary, textMuted, _notificationsOn,
              (val) => setState(() => _notificationsOn = val)),
          _buildDivider(isDark),
          _buildNavItem('Dispositivos', '${user.dispositivos.length} vinculados', textPrimary, textMuted, () {}),
          _buildDivider(isDark),
          _buildToggleItem(
            'Modo oscuro',
            isDark ? 'Activado' : 'Desactivado',
            textPrimary, textMuted,
            isDark,
            (val) {
              EnerLexApp.of(context)?.setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
            },
          ),
          _buildDivider(isDark),
          _buildNavItem('Seguridad', 'Autenticación 2FA', textPrimary, textMuted, () {}),
          _buildDivider(isDark),
          _buildNavItem('Acerca de', 'Versión 1.0.2', textPrimary, textMuted, () {}, isLast: true),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, String subtitle, Color textPrimary, Color textMuted, VoidCallback onTap, {bool isLast = false}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(color: textMuted, fontSize: 13)),
              ],
            )),
            Icon(Icons.chevron_right, color: textMuted, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem(String title, String subtitle, Color textPrimary, Color textMuted, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(color: textMuted, fontSize: 13)),
            ],
          )),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: value, onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: _accent,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFF2E3348),
              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) => Divider(
    height: 1, thickness: 1,
    color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.06),
    indent: 16, endIndent: 16,
  );

  Widget _buildLogoutButton(Color cardBg) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _redColor.withOpacity(0.3), width: 1),
      ),
      child: TextButton.icon(
        onPressed: _cerrarSesion,
        icon: const Icon(Icons.logout, color: _redColor, size: 20),
        label: const Text('Cerrar sesión', style: TextStyle(color: _redColor, fontSize: 15, fontWeight: FontWeight.w600)),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}