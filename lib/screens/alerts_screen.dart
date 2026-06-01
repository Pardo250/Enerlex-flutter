import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  static const Color _background = Color(0xFF0F1117);
  static const Color _cardBg = Color(0xFF1A1D27);
  static const Color _cardGreen = Color(0xFF0F2A1E);
  static const Color _accent = Color(0xFF00E5A0);
  static const Color _textMuted = Color(0xFF6B7280);
  static const Color _textPrimary = Color(0xFFE5E7EB);
  static const Color _redBar = Color(0xFFEF4444);
  static const Color _orangeBar = Color(0xFFFF6B35);
  static const Color _yellowDot = Color(0xFFFFB800);

  final List<Map<String, dynamic>> _alerts = const [
    {
      'device': 'Sistema Global',
      'message': '¡Sobrecarga térmica! 12 disp. (8832 W)',
      'color': _redBar,
      'time': 'Ahora',
    },
    {
      'device': 'Microondas',
      'message': 'Consumo extremadamente alto (1200W)',
      'color': _redBar,
      'time': 'Ahora',
    },
    {
      'device': 'Lavadora',
      'message': 'Consumo elevado y pesado detectado (500W)',
      'color': _orangeBar,
      'time': 'Ahora',
    },
    {
      'device': 'Aire Acondicionado',
      'message': 'Consumo extremadamente alto (1500W)',
      'color': _redBar,
      'time': 'Ahora',
    },
    {
      'device': 'Cafetera',
      'message': 'Consumo elevado y pesado detectado (800W)',
      'color': _orangeBar,
      'time': 'Ahora',
    },
    {
      'device': 'Secadora',
      'message': 'Consumo extremadamente alto (2500W)',
      'color': _redBar,
      'time': 'Ahora',
    },
  ];

  final List<String> _recommendations = const [
    'Por favor, apaga o desconecta dispositivos de alto consumo para evitar una falla eléctrica.',
    'Asegúrate de no dejar Microondas encendido si no es necesario.',
    'Revisa si puedes activar el modo ahorro en Lavadora.',
    'Asegúrate de no dejar Aire Acondicionado encendido si no es necesario.',
    'Revisa si puedes activar el modo ahorro en Cafetera.',
    'Asegúrate de no dejar Secadora encendido si no es necesario.',
    'Asegúrate de no dejar Freidora de Aire encendido si no es necesario.',
  ];

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
                  const SizedBox(height: 20),
                  ..._alerts.map(_buildAlertCard),
                  const SizedBox(height: 28),
                  _buildRecommendationsSection(),
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alertas',
          style: TextStyle(
            color: _textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${_alerts.length} alertas activas',
          style: const TextStyle(color: _textMuted, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final Color barColor = alert['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.hardEdge,
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Colored left bar
            Container(
              width: 4,
              color: barColor,
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert['device'] as String,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alert['message'] as String,
                      style: TextStyle(
                        color: barColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      alert['time'] as String,
                      style: const TextStyle(
                        color: _textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RECOMENDACIONES',
          style: TextStyle(
            color: _textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        ..._recommendations.map(_buildRecommendationCard),
      ],
    );
  }

  Widget _buildRecommendationCard(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _cardGreen,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _accent.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '💡',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 13.5,
                height: 1.4,
              ),
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
          _navItem(Icons.devices_outlined, 'Dispositivos'),
          _navItem(Icons.notifications_rounded, 'Alertas', selected: true),
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