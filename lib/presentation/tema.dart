import 'package:flutter/material.dart';

class Paleta {
  static const azul = Color(0xFF1B3A6B);
  static const azulProfundo = Color(0xFF0F2347);
  static const terracota = Color(0xFFE4572E);
  static const dorado = Color(0xFFF2B134);
  static const crema = Color(0xFFFFF8EE);
  static const turquesa = Color(0xFF2A9D8F);
  static const tinta = Color(0xFF1E2A3A);
}

const fondoHeroe = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Paleta.azulProfundo, Paleta.azul, Color(0xFF2E5AA8)],
);

ThemeData construirTema() {
  final esquema = ColorScheme.fromSeed(seedColor: Paleta.azul).copyWith(
    primary: Paleta.azul,
    secondary: Paleta.terracota,
    tertiary: Paleta.dorado,
    surface: Paleta.crema,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: esquema,
    scaffoldBackgroundColor: Paleta.crema,
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}

/// Entrada suave: aparece y sube un poco. [retrasoMs] escalona varios widgets.
class Aparecer extends StatelessWidget {
  final Widget child;
  final int retrasoMs;

  const Aparecer({super.key, required this.child, this.retrasoMs = 0});

  @override
  Widget build(BuildContext context) {
    const duracionMs = 500;
    final total = duracionMs + retrasoMs;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: total),
      curve: Interval(retrasoMs / total, 1.0, curve: Curves.easeOutCubic),
      builder: (context, valor, hijo) => Opacity(
        opacity: valor,
        child: Transform.translate(
          offset: Offset(0, 18 * (1 - valor)),
          child: hijo,
        ),
      ),
      child: child,
    );
  }
}

/// Transición entre pantallas: fundido con un leve deslizamiento hacia arriba.
Route<T> rutaSuave<T>(Widget pantalla) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 420),
    reverseTransitionDuration: const Duration(milliseconds: 320),
    pageBuilder: (_, __, ___) => pantalla,
    transitionsBuilder: (_, animacion, __, hijo) {
      final curva = CurvedAnimation(parent: animacion, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curva,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(curva),
          child: hijo,
        ),
      );
    },
  );
}