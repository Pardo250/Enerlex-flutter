import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Dispositivo {
  final String id;
  final String nombre;
  final IconData icono;
  final int watts;
  final double kwh;
  bool encendido;

  Dispositivo({
    required this.id,
    required this.nombre,
    required this.icono,
    required this.watts,
    required this.kwh,
    required this.encendido,
  });

  factory Dispositivo.fromMap(Map<String, dynamic> map) {
    return Dispositivo(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      icono: _iconFromString(map['icono'] ?? ''),
      watts: map['watts'] ?? 0,
      kwh: (map['kwh_hoy'] ?? 0).toDouble(),
      encendido: map['encendido'] ?? false,
    );
  }

  static IconData _iconFromString(String icono) {
    switch (icono) {
      case 'tv_outlined':                    return Icons.tv_outlined;
      case 'kitchen_outlined':               return Icons.kitchen_outlined;
      case 'computer_outlined':              return Icons.computer_outlined;
      case 'lightbulb_outline':              return Icons.lightbulb_outline;
      case 'microwave_outlined':             return Icons.microwave_outlined;
      case 'wind_power_outlined':            return Icons.wind_power_outlined;
      case 'local_laundry_service_outlined': return Icons.local_laundry_service_outlined;
      case 'ac_unit':                        return Icons.ac_unit;
      case 'dry_outlined':                   return Icons.dry_outlined;
      default:                               return Icons.devices_outlined;
    }
  }
}

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  // ─── Usuario ───────────────────────────────────────────
  String _nombre = '';
  String _correo = '';
  String _password = '';
  bool _isDarkMode = true;
  bool _cargando = false;

  String get nombre => _nombre;
  String get correo => _correo;
  String get password => _password;
  bool get isDarkMode => _isDarkMode;
  bool get cargando => _cargando;
  String get inicial => _nombre.isNotEmpty ? _nombre[0].toUpperCase() : 'U';

  void registrar({required String nombre, required String correo, required String password}) {
    _nombre = nombre;
    _correo = correo;
    _password = password;
    notifyListeners();
  }

  void actualizarNombre(String v) { _nombre = v; notifyListeners(); }
  void actualizarPassword(String v) { _password = v; notifyListeners(); }
  void setDarkMode(bool value) { _isDarkMode = value; notifyListeners(); }

  void cerrarSesion() {
    _nombre = '';
    _correo = '';
    _password = '';
    _dispositivos.clear();
    notifyListeners();
  }

  // ─── Dispositivos ──────────────────────────────────────
  final List<Dispositivo> _dispositivos = [];
  List<Dispositivo> get dispositivos => _dispositivos;

  /// Carga los dispositivos del usuario desde Supabase
  Future<void> cargarDispositivos() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    _cargando = true;
    notifyListeners();

    try {
      final data = await Supabase.instance.client
          .from('dispositivos')
          .select()
          .eq('user_id', user.id)
          .order('created_at');

      _dispositivos.clear();
      for (final item in data) {
        _dispositivos.add(Dispositivo.fromMap(item));
      }
    } catch (e) {
      debugPrint('Error cargando dispositivos: $e');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  /// Prende o apaga un dispositivo y guarda en Supabase
  Future<void> toggleDispositivo(int index) async {
    final d = _dispositivos[index];
    final nuevoEstado = !d.encendido;

    // Actualizar localmente primero (UI inmediata)
    _dispositivos[index].encendido = nuevoEstado;
    notifyListeners();

    // Guardar en Supabase
    try {
      await Supabase.instance.client
          .from('dispositivos')
          .update({'encendido': nuevoEstado})
          .eq('id', d.id);
    } catch (e) {
      // Si falla, revertir el cambio local
      _dispositivos[index].encendido = !nuevoEstado;
      notifyListeners();
      debugPrint('Error actualizando dispositivo: $e');
    }
  }

  // ─── Helpers ───────────────────────────────────────────
  List<Dispositivo> get encendidos => _dispositivos.where((d) => d.encendido).toList();
  int get totalWatts => encendidos.fold(0, (s, d) => s + d.watts);

  static const int umbralElevado  = 500;
  static const int umbralExcesivo = 1500;

  Color colorBarra(Dispositivo d) {
    if (!d.encendido) return const Color(0xFF2A3A32);
    if (d.watts >= umbralExcesivo) return const Color(0xFFEF4444);
    if (d.watts >= umbralElevado)  return const Color(0xFFFFB800);
    return const Color(0xFF00E5A0);
  }

  String nivelConsumo(Dispositivo d) {
    if (d.watts >= umbralExcesivo) return 'Excesivo';
    if (d.watts >= umbralElevado)  return 'Elevado';
    return 'Normal';
  }

  Color nivelColor(Dispositivo d) {
    if (d.watts >= umbralExcesivo) return const Color(0xFFEF4444);
    if (d.watts >= umbralElevado)  return const Color(0xFFFFB800);
    return const Color(0xFF00E5A0);
  }

  List<Dispositivo> get dispositivosConAlerta =>
      encendidos.where((d) => d.watts >= umbralElevado).toList();
}