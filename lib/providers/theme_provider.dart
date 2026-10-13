import 'package:flutter/material.dart';

/// Menyimpan pilihan tema terang atau gelap aplikasi.
///
/// Default-nya terang karena NusaBookstore adalah aplikasi katalog yang
/// berpusat pada teks, bukan alat pengembang.
class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
