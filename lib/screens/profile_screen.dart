import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: 'Juan Camilo Cifuentes');
  final TextEditingController _currentPasswordController =
      TextEditingController();
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

  // Monthly consumption data (kWh)
  final List<double> _monthlyData = [95, 110, 88, 125, 140, 130.8];
  final List<String> _months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];

  @override
  void dispose() {
    _nameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: _textPrimary, size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Mi perfil',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
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
                            radius: 40,
                            backgroundColor: _accent,
                            child: const Text(
                              'J',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'camilo@gmail.com',
                            style: TextStyle(color: _textMuted, fontSize: 14),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Historic consumption chart
                    _buildChartCard(),

                    const SizedBox(height: 24),

                    // Edit profile
                    const Text(
                      'Editar perfil',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildLabel('Nombre completo'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _nameController,
                      hint: 'Nombre completo',
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accent,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Guardar cambios',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Change password
                    const Text(
                      'Cambiar contraseña',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _currentPasswordController,
                      hint: 'Contraseña actual',
                      obscure: _obscureCurrent,
                      onToggle: () =>
                          setState(() => _obscureCurrent = !_obscureCurrent),
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _newPasswordController,
                      hint: 'Nueva contraseña',
                      obscure: _obscureNew,
                      onToggle: () =>
                          setState(() => _obscureNew = !_obscureNew),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _accent,
                          side: const BorderSide(color: _accent, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Actualizar contraseña',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Danger zone
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _redBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: _redColor.withOpacity(0.3), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Zona de peligro',
                            style: TextStyle(
                              color: _redColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton.icon(
                              onPressed: () => _showDeleteDialog(context),
                              icon: const Icon(Icons.delete_outline,
                                  color: _redColor, size: 20),
                              label: const Text(
                                'Eliminar mi cuenta',
                                style: TextStyle(
                                  color: _redColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: _redColor.withOpacity(0.5),
                                    width: 1.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
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
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TU CONSUMO HISTÓRICO',
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
                '130.8',
                style: TextStyle(
                  color: _accent,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(
                  'kWh / mes prom.',
                  style: TextStyle(color: _textMuted, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 80,
            child: _LineChart(data: _monthlyData, months: _months),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(color: _textMuted, fontSize: 13),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    VoidCallback? onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _fieldBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: _textPrimary, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: _textMuted, fontSize: 15),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          suffixIcon: onToggle != null
              ? GestureDetector(
                  onTap: onToggle,
                  child: Icon(
                    obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: _textMuted,
                    size: 22,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('¿Eliminar cuenta?',
            style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w700)),
        content: const Text(
          'Esta acción es irreversible. Se eliminarán todos tus datos.',
          style: TextStyle(color: _textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Cancelar', style: TextStyle(color: _textMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Eliminar',
                style: TextStyle(
                    color: _redColor, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// Custom line chart painter
class _LineChart extends StatelessWidget {
  final List<double> data;
  final List<String> months;

  const _LineChart({required this.data, required this.months});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LineChartPainter(data: data, months: months),
      child: const SizedBox.expand(),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> months;

  _LineChartPainter({required this.data, required this.months});

  @override
  void paint(Canvas canvas, Size size) {
    const Color accent = Color(0xFF00E5A0);
    const Color textMuted = Color(0xFF6B7280);

    final double maxVal = data.reduce(math.max);
    final double minVal = data.reduce(math.min);
    final double range = maxVal - minVal == 0 ? 1 : maxVal - minVal;
    final double chartHeight = size.height - 20;
    final double stepX = size.width / (data.length - 1);

    // Points
    final List<Offset> points = List.generate(data.length, (i) {
      final x = i * stepX;
      final y = chartHeight - ((data[i] - minVal) / range) * chartHeight;
      return Offset(x, y);
    });

    // Fill gradient under line
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      final cp1 = Offset(
        points[i - 1].dx + stepX / 2,
        points[i - 1].dy,
      );
      final cp2 = Offset(points[i].dx - stepX / 2, points[i].dy);
      path.cubicTo(
          cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i].dx, points[i].dy);
    }
    path.lineTo(points.last.dx, chartHeight);
    path.lineTo(points.first.dx, chartHeight);
    path.close();

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [accent.withOpacity(0.3), accent.withOpacity(0.0)],
    );
    final fillPaint = Paint()
      ..shader = gradient.createShader(
          Rect.fromLTWH(0, 0, size.width, chartHeight));
    canvas.drawPath(path, fillPaint);

    // Line
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      final cp1 = Offset(points[i - 1].dx + stepX / 2, points[i - 1].dy);
      final cp2 = Offset(points[i].dx - stepX / 2, points[i].dy);
      linePath.cubicTo(
          cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i].dx, points[i].dy);
    }
    final linePaint = Paint()
      ..color = accent
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(linePath, linePaint);

    // Dots
    final dotPaint = Paint()..color = accent;
    for (final p in points) {
      canvas.drawCircle(p, 4, dotPaint);
    }

    // Month labels
    final textStyle = const TextStyle(color: textMuted, fontSize: 11);
    for (int i = 0; i < months.length; i++) {
      final tp = TextPainter(
        text: TextSpan(text: months[i], style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(i * stepX - tp.width / 2, size.height - tp.height),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}