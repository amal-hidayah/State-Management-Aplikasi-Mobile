import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/catalog_screen.dart';

void main() {
  runApp(const NusaBookstoreApp());
}

class NusaBookstoreApp extends StatelessWidget {
  const NusaBookstoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      // Consumer di atas MaterialApp membuat perubahan tema langsung berlaku
      // ke seluruh pohon widget.
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) => MaterialApp(
          title: 'NusaBookstore',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: theme.themeMode,
          home: const CatalogScreen(),
        ),
      ),
    );
  }
}

/// Palet NusaBookstore.
///
/// Identitas "paper and ink": kertas hangat dan tinta pekat sebagai netral,
/// hijau pinus sebagai warna utama, dan kuningan sebagai satu-satunya aksen
/// yang dipakai untuk harga dan tombol Bayar.
class AppPalette {
  const AppPalette._();

  static const paper = Color(0xFFFAF5EC);
  static const paperRaised = Color(0xFFFFFDF8);
  static const ink = Color(0xFF1C1917);
  static const inkSoft = Color(0xFF5A5248);

  static const pine = Color(0xFF23503F);
  static const pineContainer = Color(0xFFD5E5DC);
  static const pineOnContainer = Color(0xFF10241C);

  static const brass = Color(0xFF8A5A12);
  static const brassContainer = Color(0xFFF3E3C6);

  static const night = Color(0xFF16130F);
  static const nightRaised = Color(0xFF221E18);
  static const nightText = Color(0xFFF2EADC);
  static const nightTextSoft = Color(0xFFC8BDA9);
  static const nightOutline = Color(0xFF6B6152);

  static const pineLight = Color(0xFF8FC7AC);
  static const brassLight = Color(0xFFE0B15C);
}

/// Tema terang dan gelap aplikasi.
///
/// Judul memakai Lora (serif literer), antarmuka memakai Source Sans 3
/// (sans humanis yang legibel di ukuran kecil). Keduanya variable font,
/// jadi bobot diatur lewat fontVariations.
class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppPalette.pine,
      onPrimary: Colors.white,
      primaryContainer: AppPalette.pineContainer,
      onPrimaryContainer: AppPalette.pineOnContainer,
      secondary: AppPalette.brass,
      onSecondary: Colors.white,
      secondaryContainer: AppPalette.brassContainer,
      onSecondaryContainer: const Color(0xFF2A1D05),
      error: const Color(0xFF8C1D18),
      onError: Colors.white,
      surface: AppPalette.paper,
      onSurface: AppPalette.ink,
      surfaceContainerHighest: AppPalette.paperRaised,
      onSurfaceVariant: AppPalette.inkSoft,
      outline: const Color(0xFFBFB4A3),
    );
    return _build(scheme, AppPalette.paper, AppPalette.paperRaised);
  }

  static ThemeData get dark {
    final scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppPalette.pineLight,
      onPrimary: const Color(0xFF10241C),
      primaryContainer: const Color(0xFF2C4C3E),
      onPrimaryContainer: AppPalette.pineContainer,
      secondary: AppPalette.brassLight,
      onSecondary: const Color(0xFF2A1D05),
      secondaryContainer: const Color(0xFF4A370F),
      onSecondaryContainer: AppPalette.brassContainer,
      error: const Color(0xFFFFB4AB),
      onError: const Color(0xFF690005),
      surface: AppPalette.night,
      onSurface: AppPalette.nightText,
      surfaceContainerHighest: AppPalette.nightRaised,
      onSurfaceVariant: AppPalette.nightTextSoft,
      outline: AppPalette.nightOutline,
    );
    return _build(scheme, AppPalette.night, AppPalette.nightRaised);
  }

  static ThemeData _build(ColorScheme scheme, Color background, Color raised) {
    final text = _textTheme(scheme);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      textTheme: text,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: raised,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.5)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 44),
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: text.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size(44, 44)),
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: scheme.secondary,
        textColor: scheme.onSecondary,
        textStyle: text.labelSmall,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outline.withValues(alpha: 0.4),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.onSurface,
        contentTextStyle: _sans(15, 400, color: scheme.surface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  static TextTheme _textTheme(ColorScheme scheme) {
    return TextTheme(
      titleLarge: _serif(22, 600, color: scheme.onSurface),
      titleMedium: _serif(18, 600, color: scheme.onSurface, height: 1.25),
      titleSmall: _sans(15, 600, color: scheme.onSurface),
      bodyLarge: _sans(16, 400, color: scheme.onSurface, height: 1.4),
      bodyMedium: _sans(14.5, 400, color: scheme.onSurfaceVariant, height: 1.4),
      bodySmall: _sans(13, 400, color: scheme.onSurfaceVariant),
      labelLarge: _sans(15, 600, color: scheme.onSurface),
      labelMedium: _sans(13, 600, color: scheme.onSurfaceVariant),
      labelSmall: _sans(11, 700, color: scheme.onSurface),
    );
  }

  static TextStyle _serif(
    double size,
    double weight, {
    Color? color,
    double? height,
  }) {
    return TextStyle(
      fontFamily: 'Lora',
      fontSize: size,
      color: color,
      height: height,
      fontWeight: _weight(weight),
      fontVariations: [FontVariation('wght', weight)],
    );
  }

  static TextStyle _sans(
    double size,
    double weight, {
    Color? color,
    double? height,
  }) {
    return TextStyle(
      fontFamily: 'SourceSans3',
      fontSize: size,
      color: color,
      height: height,
      fontWeight: _weight(weight),
      fontVariations: [FontVariation('wght', weight)],
    );
  }

  static FontWeight _weight(double weight) {
    if (weight >= 700) return FontWeight.w700;
    if (weight >= 600) return FontWeight.w600;
    if (weight >= 500) return FontWeight.w500;
    return FontWeight.w400;
  }
}
