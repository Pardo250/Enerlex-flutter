import 'package:flutter/material.dart';
import 'package:enerlex_flutter_project/app_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _selectedBar;

  static const Color _background  = Color(0xFF0F1117);
  static const Color _cardBg      = Color(0xFF1A1D27);
  static const Color _accent      = Color(0xFF00E5A0);
  static const Color _textMuted   = Color(0xFF6B7280);
  static const Color _textPrimary = Color(0xFFE5E7EB);
  static const Color _alertBg     = Color(0xFF2A1A1A);
  static const Color _alertRed    = Color(0xFFEF4444);

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

  void _onStateChanged() => setState(() { _selectedBar = null; });

  @override
  Widget build(BuildContext context) {
    final state = AppState();
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(state),
              const SizedBox(height: 20),
              _buildConsumptionCard(state),
              const SizedBox(height: 16),
              _buildChartCard(state),
              const SizedBox(height: 12),
              _buildLegend(),
              const SizedBox(height: 16),
              _buildDeviceCards(state),
              const SizedBox(height: 16),
              if (state.dispositivosConAlerta.isNotEmpty) _buildAlertCard(state),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          state.nombre.isNotEmpty ? 'Bienvenido, ${state.nombre}' : 'Bienvenido',
          style: const TextStyle(color: _textMuted, fontSize: 13),
        ),
        const SizedBox(height: 2),
        const Text('Tu hogar', style: TextStyle(color: _textPrimary, fontSize: 28, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildConsumptionCard(AppState state) {
    final kwh = (state.totalWatts * 0.001 * 8).toStringAsFixed(1);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CONSUMO TOTAL HOY', style: TextStyle(color: _textMuted, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(kwh, style: const TextStyle(color: _accent, fontSize: 52, fontWeight: FontWeight.w700, height: 1)),
              const SizedBox(width: 8),
              const Padding(padding: EdgeInsets.only(bottom: 8), child: Text('kWh', style: TextStyle(color: _textMuted, fontSize: 18, fontWeight: FontWeight.w500))),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF1E3A2A), borderRadius: BorderRadius.circular(20)),
                child: Text(
                  state.encendidos.isEmpty ? 'Sin consumo' : '${state.encendidos.length} activos',
                  style: const TextStyle(color: _accent, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(AppState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CONSUMO POR DISPOSITIVO', style: TextStyle(color: _textMuted, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
          const SizedBox(height: 20),
          _buildBarChart(state),
        ],
      ),
    );
  }

  Widget _buildBarChart(AppState state) {
    final devices = state.dispositivos;
    final maxWatts = devices.map((d) => d.watts).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 140,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(devices.length, (i) {
              final d = devices[i];
              final isSelected = _selectedBar == i;
              final barHeight = (d.watts / maxWatts) * 100.0;
              final color = isSelected ? Colors.white : state.colorBarra(d);
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedBar = _selectedBar == i ? null : i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: barHeight,
                          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          if (_selectedBar != null) _buildTooltip(state, maxWatts),
        ],
      ),
    );
  }

  Widget _buildTooltip(AppState state, int maxWatts) {
    final i = _selectedBar!;
    final d = state.dispositivos[i];
    final totalW = state.totalWatts;
    final pct = totalW > 0 ? '${(d.watts / totalW * 100).toStringAsFixed(1)}%' : '0%';
    final barFraction = (i + 0.5) / state.dispositivos.length;
    final color = d.encendido ? state.nivelColor(d) : _textMuted;

    return Positioned(
      bottom: (d.watts / maxWatts) * 100.0 + 8,
      left: 0, right: 0,
      child: Align(
        alignment: Alignment(barFraction * 2 - 1, 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2130),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.4), width: 1),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(d.encendido ? '$pct (${d.watts}W)' : 'Apagado', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
              Text(d.nombre, style: const TextStyle(color: _textPrimary, fontSize: 11)),
              if (d.encendido) Text(state.nivelConsumo(d), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(_accent, 'Normal'),
        const SizedBox(width: 16),
        _legendItem(const Color(0xFFFFB800), 'Elevado'),
        const SizedBox(width: 16),
        _legendItem(const Color(0xFFEF4444), 'Excesivo'),
        const SizedBox(width: 16),
        _legendItem(const Color(0xFF2A3A32), 'Apagado'),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 5),
      Text(label, style: const TextStyle(color: _textMuted, fontSize: 11)),
    ]);
  }

  Widget _buildDeviceCards(AppState state) {
    final shown = state.encendidos.take(2).toList();
    if (shown.isEmpty) return const SizedBox.shrink();
    return Row(
      children: List.generate(shown.length, (idx) {
        final d = shown[idx];
        final color = state.nivelColor(d);
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: idx == 0 && shown.length > 1 ? 8 : 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Icon(d.icono, color: _textMuted, size: 18),
                ]),
                const SizedBox(height: 10),
                Text(d.nombre, style: const TextStyle(color: _textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('${d.watts}W', style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAlertCard(AppState state) {
    final total = state.totalWatts;
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
          Row(children: [
            const Icon(Icons.warning_amber_rounded, color: _alertRed, size: 18),
            const SizedBox(width: 6),
            Expanded(child: Text('Sistema Global: ${state.encendidos.length} dispositivos encendidos', style: const TextStyle(color: _textPrimary, fontSize: 13, fontWeight: FontWeight.w600))),
          ]),
          const SizedBox(height: 6),
          Row(children: [
            Container(width: 8, height: 8, decoration: const BoxDecoration(color: _alertRed, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text('Consumo total: $total W', style: const TextStyle(color: _textPrimary, fontSize: 13)),
          ]),
          const SizedBox(height: 6),
          const Text('Ahora mismo', style: TextStyle(color: _textMuted, fontSize: 11)),
        ],
      ),
    );
  }
}