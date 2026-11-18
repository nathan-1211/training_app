import 'package:flutter/material.dart';

/// Tema escuro, textos grandes e alvos de toque generosos (mão suada, braço
/// estendido).
ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFFFF8A3D),
    brightness: Brightness.dark,
  ).copyWith(surface: const Color(0xFF111214));
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    brightness: Brightness.dark,
  );
  // Tipografia com tamanhos definidos (englishLike) + cores do tema escuro,
  // ampliada para leitura a um braço de distância.
  final typography = Typography.material2021(platform: TargetPlatform.iOS);
  final text = typography.englishLike
      .merge(base.textTheme)
      .apply(fontSizeFactor: 1.12);
  const big = Size(64, 60);
  final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
  return base.copyWith(
    scaffoldBackgroundColor: const Color(0xFF0B0B0D),
    textTheme: text,
    appBarTheme: const AppBarTheme(centerTitle: false),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: big,
        shape: shape,
        textStyle: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: big,
        shape: shape,
        textStyle: text.titleMedium,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(minimumSize: const Size(48, 52)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFF1A1B1F),
      margin: EdgeInsets.zero,
    ),
    listTileTheme: const ListTileThemeData(minVerticalPadding: 14),
  );
}
