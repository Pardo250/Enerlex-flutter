import 'package:flutter/material.dart';

class Dispositivo {
  final String nombre;
  final IconData icono;
  final int watts;
  final double kwh;
  bool encendido;

  Dispositivo({
    required this.nombre,
    required this.icono,
    required this.watts,
    required this.kwh,
    required this.encendido,
  });
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

  String get nombre => _nombre;
  String get correo => _correo;
  String get password => _password;
  bool get isDarkMode => _isDarkMode;
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
    notifyListeners();
  }

  // ─── Dispositivos ──────────────────────────────────────
  final List<Dispositivo> dispositivos = [
    Dispositivo(nombre: 'TV Sala',            icono: Icons.tv_outlined,                    watts: 150,  kwh: 1.2,  encendido: true),
    Dispositivo(nombre: 'Nevera',             icono: Icons.kitchen_outlined,               watts: 350,  kwh: 1.2,  encendido: true),
    Dispositivo(nombre: 'PC Oficina',         icono: Icons.computer_outlined,              watts: 200,  kwh: 1.6,  encendido: true),
    Dispositivo(nombre: 'Lámpara Cuarto',     icono: Icons.lightbulb_outline,              watts: 60,   kwh: 0.1,  encendido: true),
    Dispositivo(nombre: 'Microondas',         icono: Icons.microwave_outlined,             watts: 1200, kwh: 9.6,  encendido: false),
    Dispositivo(nombre: 'Ventilador',         icono: Icons.wind_power_outlined,            watts: 70,   kwh: 0.56, encendido: true),
    Dispositivo(nombre: 'Lavadora',           icono: Icons.local_laundry_service_outlined, watts: 500,  kwh: 4.0,  encendido: false),
    Dispositivo(nombre: 'Aire Acondicionado', icono: Icons.ac_unit,                        watts: 1500, kwh: 12.0, encendido: false),
    Dispositivo(nombre: 'Secadora',           icono: Icons.dry_outlined,                   watts: 2500, kwh: 20.0, encendido: false),
  ];

  void toggleDispositivo(int index) {
    dispositivos[index].encendido = !dispositivos[index].encendido;
    notifyListeners();
  }

  List<Dispositivo> get encendidos => dispositivos.where((d) => d.encendido).toList();
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