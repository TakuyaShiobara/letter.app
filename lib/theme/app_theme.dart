import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Small, consistent corner radius used across cards, buttons and fields.
/// Kept modest on purpose — this app avoids the rounded, playful look of a
/// typical consumer app in favor of a quieter, stationery-like silhouette.
class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.light(
      brightness: Brightness.light,
      primary: AppColors.deepGreen,
      onPrimary: AppColors.washi,
      secondary: AppColors.deepNavy,
      onSecondary: AppColors.washi,
      tertiary: AppColors.gold,
      onTertiary: AppColors.ink,
      surface: AppColors.washiCard,
      onSurface: AppColors.ink,
      surfaceContainerHighest: AppColors.washi,
      outline: AppColors.washiBorder,
      error: const Color(0xFF8C4A3A),
      onError: AppColors.washi,
    );

    return _build(colorScheme, AppTextStyles.light, AppColors.washi);
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.dark(
      brightness: Brightness.dark,
      primary: AppColors.deepGreenDark,
      onPrimary: AppColors.inkBackground,
      secondary: AppColors.deepNavyDark,
      onSecondary: AppColors.inkBackground,
      tertiary: AppColors.gold,
      onTertiary: AppColors.inkBackground,
      surface: AppColors.inkCard,
      onSurface: AppColors.paleInk,
      surfaceContainerHighest: AppColors.inkBackground,
      outline: AppColors.inkBorder,
      error: const Color(0xFFCB8B78),
      onError: AppColors.inkBackground,
    );

    return _build(colorScheme, AppTextStyles.dark, AppColors.inkBackground);
  }

  static ThemeData _build(
    ColorScheme colorScheme,
    TextTheme textTheme,
    Color scaffoldColor,
  ) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldColor,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldColor,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: colorScheme.onSurface, size: 22),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: colorScheme.outline, width: 1),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        thickness: 1,
        space: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          minimumSize: const Size.fromHeight(52),
          side: BorderSide(color: colorScheme.outline),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurface, size: 22),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.4),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surface,
        selectedColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.outline),
        labelStyle: textTheme.labelLarge,
        secondaryLabelStyle: textTheme.labelLarge?.copyWith(
          color: colorScheme.onPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        showCheckmark: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scaffoldColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.12),
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelSmall),
        height: 68,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _FadeThroughTransitionsBuilder(),
          TargetPlatform.iOS: _FadeThroughTransitionsBuilder(),
          TargetPlatform.macOS: _FadeThroughTransitionsBuilder(),
          TargetPlatform.windows: _FadeThroughTransitionsBuilder(),
          TargetPlatform.linux: _FadeThroughTransitionsBuilder(),
        },
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.onSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.surface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
    );
  }
}

/// A quiet fade + gentle rise, matching the "no flashy motion" direction.
class _FadeThroughTransitionsBuilder extends PageTransitionsBuilder {
  const _FadeThroughTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.02),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
