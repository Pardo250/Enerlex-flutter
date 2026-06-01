import 'package:flutter/material.dart';
import 'package:enerlex_flutter_project/app_state.dart';
import 'register_screen.dart';
import 'main_scaffold.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static const Color _background = Color(0xFF0F1117);
  static const Color _fieldBg    = Color(0xFF1E2130);
  static const Color _accent     = Color(0xFF00E5A0);
  static const Color _textMuted  = Color(0xFF6B7280);
  static const Color _textPrimary= Color(0xFFE5E7EB);
  static const Color _iconBg     = Color(0xFF1E2A25);
  static const Color _redColor   = Color(0xFFEF4444);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _iniciarSesion() {
    final correo = _emailController.text.trim();
    final password = _passwordController.text;

    if (correo.isEmpty || password.isEmpty) {
      _showError('Por favor completa todos los campos.');
      return;
    }

    // Guardar correo en AppState para que aparezca en Config y Perfil
    // El nombre se deriva de la parte antes del @ si no hay nombre guardado
    final nombreGuardado = AppState().nombre;
    final nombreFinal = nombreGuardado.isNotEmpty
        ? nombreGuardado
        : correo.split('@').first;

    AppState().registrar(
      nombre: nombreFinal,
      correo: correo,
      password: password,
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScaffold()),
      (route) => false,
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: _redColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              children: [
                const SizedBox(height: 72),
                // Logo
                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(color: _iconBg, borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Container(width: 28, height: 28, decoration: const BoxDecoration(color: _accent, shape: BoxShape.circle)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('EnerLex', style: TextStyle(color: _textPrimary, fontSize: 26, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                const Text('Monitoreo inteligente de energía', style: TextStyle(color: _textMuted, fontSize: 13.5)),
                const SizedBox(height: 44),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'correo@ejemplo.com',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _passwordController,
                  hintText: '••••••••',
                  obscureText: _obscurePassword,
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                    child: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: _textMuted, size: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text('¿Olvidé mi contraseña?', style: TextStyle(color: _accent, fontSize: 13)),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity, height: 52,
                  child: ElevatedButton(
                    onPressed: _iniciarSesion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accent, foregroundColor: Colors.black, elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Iniciar sesión', style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity, height: 52,
                  child: OutlinedButton(
                    onPressed: () {
                      // Google: usar correo como nombre temporal
                      AppState().registrar(
                        nombre: 'Usuario Google',
                        correo: 'usuario@gmail.com',
                        password: '',
                      );
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const MainScaffold()),
                        (route) => false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _textPrimary,
                      side: const BorderSide(color: Color(0xFF2E3348), width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Continuar con Google', style: TextStyle(fontSize: 15.5)),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿No tienes cuenta? ', style: TextStyle(color: _textMuted, fontSize: 13.5)),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                      child: const Text('Crear cuenta', style: TextStyle(color: _accent, fontSize: 13.5, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(color: _fieldBg, borderRadius: BorderRadius.circular(14)),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(color: _textPrimary, fontSize: 15),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: _textMuted, fontSize: 15),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        ),
      ),
    );
  }
}