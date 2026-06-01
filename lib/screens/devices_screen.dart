import 'package:flutter/material.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  static const Color _background = Color(0xFF0F1117);
  static const Color _cardBg = Color(0xFF1A1D27);
  static const Color _accent = Color(0xFF00E5A0);
  static const Color _textMuted = Color(0xFF6B7280);
  static const Color _textPrimary = Color(0xFFE5E7EB);
  static const Color _dotActive = Color(0xFF00E5A0);
  static const Color _dotIdle = Color(0xFFFFB800);

  final List<Map<String, dynamic>> _devices = [
    {
      'name': 'TV Sala',
      'icon': Icons.tv_outlined,
      'watts': 150,
      'kwh': 1.2,
      'on': true,
    },
    {
      'name': 'Nevera',
      'icon': Icons.kitchen_outlined,
      'watts': 150,
      'kwh': 1.2,
      'on': true,
    },
    {
      'name': 'PC Oficina',
      'icon': Icons.computer_outlined,
      'watts': 200,
      'kwh': 1.6,
      'on': true,
    },
    {
      'name': 'Lámpara Cuarto',
      'icon': Icons.lightbulb_outline,
      'watts': 12,
      'kwh': 0.1,
      'on': true,
    },
    {
      'name': 'Microondas',
      'icon': Icons.microwave_outlined,
      'watts': 1200,
      'kwh': 9.6,
      'on': false,
    },
    {
      'name': 'Ventilador',
      'icon': Icons.ac_unit_outlined,
      'watts': 70,
      'kwh': 0.56,
      'on': true,
    },
    {
      'name': 'Lavadora',
      'icon': Icons.local_laundry_service_outlined,
      'watts': 500,
      'kwh': 4.0,
      'on': false,
    },
    {
      'name': 'Aire Acondicionado',
      'icon': Icons.ac_unit,
      'watts': 1500,
      'kwh': 12.0,
      'on': false,
    },
  ];

  int get _totalOn => _devices.where((d) => d['on'] as bool).length;

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
                  _buildHeader(),
                  const SizedBox(height: 24),
                  ..._devices.asMap().entries.map((e) => _buildDeviceCard(e.key, e.value)),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dispositivos',
          style: TextStyle(
            color: _textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$_totalOn encendidos · ${_devices.length} total',
          style: const TextStyle(color: _textMuted, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildDeviceCard(int index, Map<String, dynamic> device) {
    final bool isOn = device['on'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Status dot
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: isOn ? _dotActive : _dotIdle,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),

          // Device icon
          Icon(
            device['icon'] as IconData,
            color: _textMuted,
            size: 22,
          ),
          const SizedBox(width: 14),

          // Name + stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device['name'] as String,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      '${device['watts']}W',
                      style: const TextStyle(
                        color: _accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      '  ·  ',
                      style: TextStyle(color: _textMuted, fontSize: 13),
                    ),
                    Text(
                      '${device['kwh']} kWh hoy',
                      style: const TextStyle(
                        color: _textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Toggle
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: isOn,
              onChanged: (val) {
                setState(() {
                  _devices[index]['on'] = val;
                });
              },
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
          _navItem(Icons.devices_outlined, 'Dispositivos', selected: true),
          _navItem(Icons.notifications_outlined, 'Alertas'),
          _navItem(Icons.settings_outlined, 'Config'),
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