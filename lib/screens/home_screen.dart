import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _selectedBar;

  static const Color _background = Color(0xFF0F1117);
  static const Color _cardBg = Color(0xFF1A1D27);
  static const Color _accent = Color(0xFF00E5A0);
  static const Color _textMuted = Color(0xFF6B7280);
  static const Color _textPrimary = Color(0xFFE5E7EB);
  static const Color _alertBg = Color(0xFF2A1A1A);
  static const Color _alertRed = Color(0xFFEF4444);

  // Devices shown in the bar chart
  final List<Map<String, dynamic>> _devices = [
    {'name': 'Lavadora', 'watts': 800, 'active': false},
    {'name': 'Nevera', 'watts': 350, 'active': false},
    {'name': 'TV', 'watts': 120, 'active': false},
    {'name': 'Microondas', 'watts': 1100, 'active': false},
    {'name': 'Computador', 'watts': 400, 'active': false},
    {'name': 'Horno', 'watts': 2000, 'active': true},
    {'name': 'Bombillas', 'watts': 60, 'active': false},
    {'name': 'Secadora', 'watts': 2500, 'active': true},
    {'name': 'Aire Acondicionado', 'watts': 1500, 'active': true},
  ];

  int get _totalWatts =>
      _devices.fold(0, (sum, d) => sum + (d['watts'] as int));

  String _percent(int watts) =>
      '${(watts / _totalWatts * 100).toStringAsFixed(1)}%';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildConsumptionCard(),
                    const SizedBox(height: 16),
                    _buildChartCard(),
                    const SizedBox(height: 16),
                    _buildDeviceCards(),
                    const SizedBox(height: 16),
                    _buildAlertCard(),
                    const SizedBox(height: 20),
                  ],
                ),
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
          'Bienvenido, Juan Camilo Cifuentes',
          style: TextStyle(color: _textMuted, fontSize: 13),
        ),
        const SizedBox(height: 2),
        const Text(
          'Tu hogar',
          style: TextStyle(
            color: _textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildConsumptionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CONSUMO TOTAL HOY',
            style: TextStyle(
              color: _textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '70.7',
                style: TextStyle(
                  color: _accent,
                  fontSize: 52,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'kWh',
                  style: TextStyle(
                    color: _textMuted,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A2A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '12% eficiente',
                  style: TextStyle(
                    color: _accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CONSUMO POR DISPOSITIVO',
            style: TextStyle(
              color: _textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          _buildBarChart(),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    final maxWatts = _devices
        .map((d) => d['watts'] as int)
        .reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 140,
      child: Stack(
        children: [
          // Bars row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(_devices.length, (i) {
              final device = _devices[i];
              final watts = device['watts'] as int;
              final isActive = device['active'] as bool;
              final isSelected = _selectedBar == i;
              final barHeight = (watts / maxWatts) * 100.0;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedBar = _selectedBar == i ? null : i;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : isActive
                                    ? _accent
                                    : const Color(0xFF2A3A32),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),

          // Tooltip
          if (_selectedBar != null)
            _buildTooltip(maxWatts),
        ],
      ),
    );
  }

  Widget _buildTooltip(int maxWatts) {
    final i = _selectedBar!;
    final device = _devices[i];
    final watts = device['watts'] as int;
    final name = device['name'] as String;
    final percent = _percent(watts);

    // Calculate horizontal position
    final barFraction = (i + 0.5) / _devices.length;

    return Positioned(
      bottom: (watts / maxWatts) * 100.0 + 8,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment(barFraction * 2 - 1, 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2130),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _accent.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$percent (${watts}W)',
                style: const TextStyle(
                  color: _accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                name,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceCards() {
    final activeDevices =
        _devices.where((d) => d['active'] as bool).toList();
    // Show first 2 active devices
    final shown = activeDevices.take(2).toList();

    return Row(
      children: shown.map((device) {
        final isAC = (device['name'] as String).contains('Aire');
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: shown.indexOf(device) == 0 ? 8 : 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isAC ? Colors.amber : _accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      isAC ? Icons.ac_unit : Icons.local_laundry_service,
                      color: _textMuted,
                      size: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  device['name'] as String,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${device['watts']}W',
                  style: const TextStyle(
                    color: _accent,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAlertCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _alertBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _alertRed.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: _alertRed, size: 18),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Sistema Global: ¡Sobrecarga térmica! 12',
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: _alertRed,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'dispositivos encendidos (8832 W)',
                style: TextStyle(color: _textPrimary, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Ahora mismo',
            style: TextStyle(color: _textMuted, fontSize: 11),
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
          _navItem(Icons.home_rounded, 'Inicio', selected: true),
          _navItem(Icons.devices_outlined, 'Dispositivos'),
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