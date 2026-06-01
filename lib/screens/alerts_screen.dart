import 'package:flutter/material.dart';
import 'package:enerlex_flutter_project/app_state.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});
  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  static const Color _background  = Color(0xFF0F1117);
  static const Color _cardBg      = Color(0xFF1A1D27);
  static const Color _cardGreen   = Color(0xFF0F2A1E);
  static const Color _accent      = Color(0xFF00E5A0);
  static const Color _textMuted   = Color(0xFF6B7280);
  static const Color _textPrimary = Color(0xFFE5E7EB);
  static const Color _redBar      = Color(0xFFEF4444);
  static const Color _orangeBar   = Color(0xFFFF6B35);

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

  @override
  Widget build(BuildContext context) {
    final state = AppState();
    final alertas = state.dispositivosConAlerta;

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 20),
            _buildHeader(alertas.length),
            const SizedBox(height: 20),

            // Sistema global si hay sobrecarga
            if (state.totalWatts >= 3000) _buildGlobalAlert(state),

            // Alertas por dispositivo
            if (alertas.isEmpty)
              _buildEmptyAlerts()
            else
              ...alertas.map((d) => _buildAlertCard(state, d)),

            // Recomendaciones
            if (alertas.isNotEmpty) ...[
              const SizedBox(height: 28),
              _buildRecommendationsSection(state, alertas),
            ],

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Alertas', style: TextStyle(color: _textPrimary, fontSize: 28, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(
          count == 0 ? 'Sin alertas activas' : '$count alertas activas',
          style: const TextStyle(color: _textMuted, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildGlobalAlert(AppState state) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.hardEdge,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 4, color: _redBar),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sistema Global', style: TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('¡Sobrecarga! ${state.encendidos.length} disp. (${state.totalWatts}W)', style: const TextStyle(color: _redBar, fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    const Text('Ahora', style: TextStyle(color: _textMuted, fontSize: 11)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyAlerts() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(14)),
      child: const Center(
        child: Column(
          children: [
            Icon(Icons.check_circle_outline, color: Color(0xFF00E5A0), size: 40),
            SizedBox(height: 12),
            Text('Todo en orden', style: TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Text('No hay dispositivos con consumo elevado.', style: TextStyle(color: _textMuted, fontSize: 13), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(AppState state, Dispositivo d) {
    final isExcesivo = d.watts >= AppState.umbralExcesivo;
    final barColor = isExcesivo ? _redBar : _orangeBar;
    final msg = isExcesivo
        ? 'Consumo extremadamente alto (${d.watts}W)'
        : 'Consumo elevado detectado (${d.watts}W)';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.hardEdge,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 4, color: barColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d.nombre, style: const TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(msg, style: TextStyle(color: barColor, fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    const Text('Ahora', style: TextStyle(color: _textMuted, fontSize: 11)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsSection(AppState state, List<Dispositivo> alertas) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('RECOMENDACIONES', style: TextStyle(color: _textMuted, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
        const SizedBox(height: 12),
        // Recomendación global si hay sobrecarga
        if (state.totalWatts >= 3000)
          _buildRecommendationCard('Por favor, apaga o desconecta dispositivos de alto consumo para evitar una falla eléctrica.'),
        // Recomendación por cada dispositivo con alerta
        ...alertas.map((d) {
          final isExcesivo = d.watts >= AppState.umbralExcesivo;
          final msg = isExcesivo
              ? 'Asegúrate de no dejar ${d.nombre} encendido si no es necesario.'
              : 'Revisa si puedes activar el modo ahorro en ${d.nombre}.';
          return _buildRecommendationCard(msg);
        }),
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
        border: Border.all(color: _accent.withOpacity(0.15), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(color: _textPrimary, fontSize: 13.5, height: 1.4))),
        ],
      ),
    );
  }
}