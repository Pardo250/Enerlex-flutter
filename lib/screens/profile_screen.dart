import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:enerlex_flutter_project/app_state.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;

  static const Color _background = Color(0xFF0F1117);
  static const Color _cardBg = Color(0xFF1A1D27);
  static const Color _accent = Color(0xFF00E5A0);
  static const Color _textMuted = Color(0xFF6B7280);
  static const Color _textPrimary = Color(0xFFE5E7EB);
  static const Color _fieldBg = Color(0xFF1E2130);
  static const Color _redColor = Color(0xFFEF4444);
  static const Color _redBg = Color(0xFF2A1A1A);

  final List<double> _monthlyData = [95, 110, 88, 125, 140, 130.8];
  final List<String> _months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: AppState().nombre);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _guardarNombre() {
    final nuevoNombre = _nameController.text.trim();
    if (nuevoNombre.isEmpty) {
      _showSnack('El nombre no puede estar vacío.', error: true);
      return;
    }
    AppState().actualizarNombre(nuevoNombre);
    _showSnack('Nombre actualizado correctamente.');
  }

  void _actualizarPassword() {
    final actual = _currentPasswordController.text;
    final nueva = _newPasswordController.text;

    if (actual.isEmpty || nueva.isEmpty) {
      _showSnack('Completa ambos campos de contraseña.', error: true);
      return;
    }
    if (actual != AppState().password) {
      _showSnack('La contraseña actual no es correcta.', error: true);
      return;
    }
    if (nueva.length < 6) {
      _showSnack('La nueva contraseña debe tener al menos 6 caracteres.', error: true);
      return;
    }
    AppState().actualizarPassword(nueva);
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _showSnack('Contraseña actualizada correctamente.');
  }

  void _eliminarCuenta() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('¿Eliminar cuenta?', style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w700)),
        content: const Text('Esta acción es irreversible. Se eliminarán todos tus datos.', style: TextStyle(color: _textMuted)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar', style: TextStyle(color: _textMuted))),
          TextButton(
            onPressed: () {
              AppState().cerrarSesion();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: _redColor, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showSnack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? _redColor : _accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AppState();
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: _textPrimary, size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Text('Mi perfil', style: TextStyle(color: _textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar + email
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40, backgroundColor: _accent,
                            child: Text(user.inicial, style: const TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(height: 12),
                          Text(user.correo, style: const TextStyle(color: _textMuted, fontSize: 14)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    _buildChartCard(),
                    const SizedBox(height: 24),

                    // Editar perfil
                    const Text('Editar perfil', style: TextStyle(color: _textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    const Text('Nombre completo', style: TextStyle(color: _textMuted, fontSize: 13)),
                    const SizedBox(height: 6),
                    _buildTextField(controller: _nameController, hint: 'Nombre completo'),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity, height: 50,
                      child: ElevatedButton(
                        onPressed: _guardarNombre,
                        style: ElevatedButton.styleFrom(backgroundColor: _accent, foregroundColor: Colors.black, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        child: const Text('Guardar cambios', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Cambiar contraseña
                    const Text('Cambiar contraseña', style: TextStyle(color: _textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    _buildTextField(controller: _currentPasswordController, hint: 'Contraseña actual', obscure: _obscureCurrent, onToggle: () => setState(() => _obscureCurrent = !_obscureCurrent)),
                    const SizedBox(height: 10),
                    _buildTextField(controller: _newPasswordController, hint: 'Nueva contraseña', obscure: _obscureNew, onToggle: () => setState(() => _obscureNew = !_obscureNew)),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity, height: 50,
                      child: OutlinedButton(
                        onPressed: _actualizarPassword,
                        style: OutlinedButton.styleFrom(foregroundColor: _accent, side: const BorderSide(color: _accent, width: 1.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        child: const Text('Actualizar contraseña', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Zona de peligro
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: _redBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: _redColor.withOpacity(0.3), width: 1)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Zona de peligro', style: TextStyle(color: _redColor, fontSize: 15, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity, height: 50,
                            child: OutlinedButton.icon(
                              onPressed: _eliminarCuenta,
                              icon: const Icon(Icons.delete_outline, color: _redColor, size: 20),
                              label: const Text('Eliminar mi cuenta', style: TextStyle(color: _redColor, fontSize: 15, fontWeight: FontWeight.w600)),
                              style: OutlinedButton.styleFrom(side: BorderSide(color: _redColor.withOpacity(0.5), width: 1.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('TU CONSUMO HISTÓRICO', style: TextStyle(color: _textMuted, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('130.8', style: TextStyle(color: _accent, fontSize: 40, fontWeight: FontWeight.w700, height: 1)),
              const SizedBox(width: 8),
              const Padding(padding: EdgeInsets.only(bottom: 6), child: Text('kWh / mes prom.', style: TextStyle(color: _textMuted, fontSize: 14))),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(height: 80, child: _LineChart(data: _monthlyData, months: _months)),
        ],
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, bool obscure = false, VoidCallback? onToggle}) {
    return Container(
      decoration: BoxDecoration(color: _fieldBg, borderRadius: BorderRadius.circular(14)),
      child: TextField(
        controller: controller, obscureText: obscure,
        style: const TextStyle(color: _textPrimary, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint, hintStyle: const TextStyle(color: _textMuted, fontSize: 15),
          border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          suffixIcon: onToggle != null ? GestureDetector(onTap: onToggle, child: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: _textMuted, size: 22)) : null,
        ),
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  final List<double> data;
  final List<String> months;
  const _LineChart({required this.data, required this.months});

  @override
  Widget build(BuildContext context) => CustomPaint(painter: _LineChartPainter(data: data, months: months), child: const SizedBox.expand());
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> months;
  _LineChartPainter({required this.data, required this.months});

  @override
  void paint(Canvas canvas, Size size) {
    const accent = Color(0xFF00E5A0);
    const textMuted = Color(0xFF6B7280);
    final maxVal = data.reduce(math.max);
    final minVal = data.reduce(math.min);
    final range = maxVal - minVal == 0 ? 1.0 : maxVal - minVal;
    final chartHeight = size.height - 20;
    final stepX = size.width / (data.length - 1);

    final points = List.generate(data.length, (i) => Offset(i * stepX, chartHeight - ((data[i] - minVal) / range) * chartHeight));

    final fillPath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      fillPath.cubicTo(points[i-1].dx + stepX/2, points[i-1].dy, points[i].dx - stepX/2, points[i].dy, points[i].dx, points[i].dy);
    }
    fillPath.lineTo(points.last.dx, chartHeight);
    fillPath.lineTo(points.first.dx, chartHeight);
    fillPath.close();
    canvas.drawPath(fillPath, Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [accent.withOpacity(0.3), accent.withOpacity(0.0)]).createShader(Rect.fromLTWH(0, 0, size.width, chartHeight)));

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      linePath.cubicTo(points[i-1].dx + stepX/2, points[i-1].dy, points[i].dx - stepX/2, points[i].dy, points[i].dx, points[i].dy);
    }
    canvas.drawPath(linePath, Paint()..color = accent..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
    for (final p in points) canvas.drawCircle(p, 4, Paint()..color = accent);

    for (int i = 0; i < months.length; i++) {
      final tp = TextPainter(text: TextSpan(text: months[i], style: const TextStyle(color: textMuted, fontSize: 11)), textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, Offset(i * stepX - tp.width / 2, size.height - tp.height));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}