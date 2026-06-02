import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:enerlex_flutter_project/app_state.dart';
import 'main_scaffold.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  static const Color _background  = Color(0xFF0F1117);
  static const Color _fieldBg     = Color(0xFF1E2130);
  static const Color _accent      = Color(0xFF00E5A0);
  static const Color _textMuted   = Color(0xFF6B7280);
  static const Color _textPrimary = Color(0xFFE5E7EB);
  static const Color _iconBg      = Color(0xFF1E2A25);
  static const Color _redColor    = Color(0xFFEF4444);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _crearCuenta() async {
    final nombre = _nameController.text.trim();
    final correo = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (nombre.isEmpty || correo.isEmpty || password.isEmpty) {
      _showSnack('Por favor completa todos los campos.', error: true);
      return;
    }
    if (password != confirm) {
      _showSnack('Las contraseñas no coinciden.', error: true);
      return;
    }
    if (password.length < 6) {
      _showSnack('La contraseña debe tener al menos 6 caracteres.', error: true);
      return;
    }

    setState(() => _loading = true);

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: correo,
        password: password,
        data: {'nombre': nombre},
      );

      if (response.user != null) {
        AppState().registrar(nombre: nombre, correo: correo, password: password);

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainScaffold()),
            (route) => false,
          );
        }
      }
    } on AuthException catch (e) {
      _showSnack(e.message, error: true);
    } catch (e) {
      _showSnack('Error al crear la cuenta. Intenta de nuevo.', error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: _textPrimary, size: 24)),
              const SizedBox(height: 32),
              Center(
                child: Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(color: _iconBg, borderRadius: BorderRadius.circular(20)),
                  child: Center(child: Container(width: 28, height: 28, decoration: const BoxDecoration(color: _accent, shape: BoxShape.circle))),
                ),
              ),
              const SizedBox(height: 20),
              const Center(child: Text('Crear cuenta', style: TextStyle(color: _textPrimary, fontSize: 26, fontWeight: FontWeight.w700))),
              const SizedBox(height: 6),
              const Center(child: Text('Únete a EnerFlow', style: TextStyle(color: _textMuted, fontSize: 13.5))),
              const SizedBox(height: 36),
              _buildTextField(controller: _nameController, hintText: 'Nombre completo', keyboardType: TextInputType.name),
              const SizedBox(height: 14),
              _buildTextField(controller: _emailController, hintText: 'Correo electrónico', keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _passwordController, hintText: 'Contraseña', obscureText: _obscurePassword,
                suffixIcon: GestureDetector(onTap: () => setState(() => _obscurePassword = !_obscurePassword), child: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: _textMuted, size: 22)),
              ),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _confirmController, hintText: 'Confirmar contraseña', obscureText: _obscureConfirm,
                suffixIcon: GestureDetector(onTap: () => setState(() => _obscureConfirm = !_obscureConfirm), child: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: _textMuted, size: 22)),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _crearCuenta,
                  style: ElevatedButton.styleFrom(backgroundColor: _accent, foregroundColor: Colors.black, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: _loading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                      : const Text('Crear cuenta', style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿Ya tienes cuenta? ', style: TextStyle(color: _textMuted, fontSize: 13.5)),
                  GestureDetector(onTap: () => Navigator.pop(context), child: const Text('Iniciar sesión', style: TextStyle(color: _accent, fontSize: 13.5, fontWeight: FontWeight.w600))),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hintText, TextInputType keyboardType = TextInputType.text, bool obscureText = false, Widget? suffixIcon}) {
    return Container(
      decoration: BoxDecoration(color: _fieldBg, borderRadius: BorderRadius.circular(14)),
      child: TextField(
        controller: controller, keyboardType: keyboardType, obscureText: obscureText,
        style: const TextStyle(color: _textPrimary, fontSize: 15),
        decoration: InputDecoration(
          hintText: hintText, hintStyle: const TextStyle(color: _textMuted, fontSize: 15),
          suffixIcon: suffixIcon, border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        ),
      ),
    );
  }
}