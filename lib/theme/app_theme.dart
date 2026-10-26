import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

/// App-wide Material 3 theme (light + dark), built with flex_color_scheme.
/// Font: Inter, bundled as a local asset (no runtime font downloads).
class AppTheme {
  AppTheme._();

  static const _colors = FlexSchemeColor(
    primary: Color(0xFF4F46E5),
    primaryContainer: Color(0xFFE0E7FF),
    secondary: Color(0xFF0D9488),
    secondaryContainer: Color(0xFFCCFBF1),
    tertiary: Color(0xFFD97706),
    tertiaryContainer: Color(0xFFFEF3C7),
  );

  static const _sub = FlexSubThemesData(
    interactionEffects: true,
    defaultRadius: 20,
    cardRadius: 24,
    cardElevation: 0,
    filledButtonRadius: 18,
    outlinedButtonRadius: 18,
    textButtonRadius: 14,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    inputDecoratorIsFilled: true,
    inputDecoratorRadius: 16,
    appBarCenterTitle: false,
  );

  static ThemeData get light => _finish(
        FlexThemeData.light(
          colors: _colors,
          surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
          blendLevel: 6,
          subThemesData: _sub,
          fontFamily: 'Inter',
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
        ),
      );

  static ThemeData get dark => _finish(
        FlexThemeData.dark(
          colors: _colors.toDark(30),
          surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
          blendLevel: 12,
          subThemesData: _sub,
          fontFamily: 'Inter',
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
        ),
      );

  /// Shared touches: taller buttons and bolder titles.
  static ThemeData _finish(ThemeData base) {
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(18));
    const size = Size.fromHeight(56);
    final label = base.textTheme.labelLarge!.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
    return base.copyWith(
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: size,
          shape: shape,
          textStyle: label,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: size,
          shape: shape,
          textStyle: label,
        ),
      ),
      appBarTheme: base.appBarTheme.copyWith(
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
