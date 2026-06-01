import 'package:flutter/material.dart';
import 'package:enerlex_flutter_project/app_state.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});
  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  static const Color _background  = Color(0xFF0F1117);
  static const Color _cardBg      = Color(0xFF1A1D27);
  static const Color _accent      = Color(0xFF00E5A0);
  static const Color _textMuted   = Color(0xFF6B7280);
  static const Color _textPrimary = Color(0xFFE5E7EB);
  static const Color _dotIdle     = Color(0xFFFFB800);

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
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 20),
            _buildHeader(state),
            const SizedBox(height: 24),
            ...List.generate(state.dispositivos.length, (i) => _buildDeviceCard(state, i)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Dispositivos', style: TextStyle(color: _textPrimary, fontSize: 28, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text('${state.encendidos.length} encendidos · ${state.dispositivos.length} total', style: const TextStyle(color: _textMuted, fontSize: 13)),
      ],
    );
  }

  Widget _buildDeviceCard(AppState state, int index) {
    final d = state.dispositivos[index];
    final color = state.colorBarra(d);
    final dotColor = d.encendido ? _accent : _dotIdle;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(width: 9, height: 9, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Icon(d.icono, color: _textMuted, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d.nombre, style: const TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Row(children: [
                  Text('${d.watts}W', style: TextStyle(color: d.encendido ? color : _textMuted, fontSize: 13, fontWeight: FontWeight.w600)),
                  const Text('  ·  ', style: TextStyle(color: _textMuted, fontSize: 13)),
                  Text('${d.kwh} kWh hoy', style: const TextStyle(color: _textMuted, fontSize: 13)),
                ]),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: d.encendido,
              onChanged: (_) => state.toggleDispositivo(index),
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
}