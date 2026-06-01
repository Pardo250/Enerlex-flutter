import 'package:flutter/material.dart';
import 'profile_screen.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  bool _notificationsOn = true;
  bool _darkMode = true;

  static const Color _background = Color(0xFF0F1117);
  static const Color _cardBg = Color(0xFF1A1D27);
  static const Color _accent = Color(0xFF00E5A0);
  static const Color _textMuted = Color(0xFF6B7280);
  static const Color _textPrimary = Color(0xFFE5E7EB);
  static const Color _redColor = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 20),
                  _buildProfileCard(context),
                  const SizedBox(height: 20),
                  _buildSettingsCard(),
                  const SizedBox(height: 20),
                  _buildLogoutButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: _accent,
                  child: const Text(
                    'J',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _background,
                      shape: BoxShape.circle,
                      border: Border.all(color: _cardBg, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 11,
                      color: _textMuted,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Juan Camilo Cifuentes',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'camilo@gmail.com',
                    style: TextStyle(color: _textMuted, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Plan Hogar Premium',
                    style: TextStyle(
                      color: _accent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: _textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildNavItem(
            icon: Icons.tune_outlined,
            title: 'Límites de consumo',
            subtitle: 'Personaliza umbrales',
            onTap: () {},
          ),
          _buildDivider(),
          _buildToggleItem(
            icon: Icons.notifications_outlined,
            title: 'Notificaciones',
            subtitle: 'Push, Email, SMS',
            value: _notificationsOn,
            onChanged: (val) => setState(() => _notificationsOn = val),
          ),
          _buildDivider(),
          _buildNavItem(
            icon: Icons.devices_outlined,
            title: 'Dispositivos',
            subtitle: '8 vinculados',
            onTap: () {},
          ),
          _buildDivider(),
          _buildToggleItem(
            icon: Icons.dark_mode_outlined,
            title: 'Modo oscuro',
            subtitle: _darkMode ? 'Activado' : 'Desactivado',
            value: _darkMode,
            onChanged: (val) => setState(() => _darkMode = val),
          ),
          _buildDivider(),
          _buildNavItem(
            icon: Icons.security_outlined,
            title: 'Seguridad',
            subtitle: 'Autenticación 2FA',
            onTap: () {},
          ),
          _buildDivider(),
          _buildNavItem(
            icon: Icons.info_outline,
            title: 'Acerca de',
            subtitle: 'Versión 1.0.2',
            onTap: () {},
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: const Radius.circular(0),
        bottom: isLast ? const Radius.circular(16) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: _textMuted, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: _textMuted, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: _textMuted, fontSize: 13),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: value,
              onChanged: onChanged,
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

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.white.withOpacity(0.05),
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _redColor.withOpacity(0.3), width: 1),
      ),
      child: TextButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.logout, color: _redColor, size: 20),
        label: const Text(
          'Cerrar sesión',
          style: TextStyle(
            color: _redColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.06), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_rounded, 'Inicio'),
          _navItem(Icons.devices_outlined, 'Dispositivos'),
          _navItem(Icons.notifications_outlined, 'Alertas'),
          _navItem(Icons.settings_outlined, 'Config', selected: true),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, {bool selected = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: selected ? _accent : _textMuted, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: selected ? _accent : _textMuted,
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}