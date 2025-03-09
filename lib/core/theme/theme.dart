import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors updated to match logo
  static const Color primaryColor = Color(0xFF8559DA); // Purple from logo
  static const Color accentColor = Color(0xFFFAAA33); // Yellow/orange from logo
  static const Color secondaryAccentColor = Color(
    0xFF5C4CDD,
  ); // Blue checkmark color
  static const Color lightBackgroundColor = Color(0xFFF5F5F7);
  static const Color darkBackgroundColor = Color(0xFF303030);
  static const Color cardColorLight = Colors.white;
  static const Color cardColorDark = Color(0xFF424242);
  static const Color textPrimaryLight = Color(0xFF2E3C59);
  static const Color textPrimaryDark = Color(0xFFF5F5F7);
  static const Color textSecondaryLight = Color(0xFF6C7A9C);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  // Priority Colors
  static const Color priorityHigh = Color(0xFFE57373);
  static const Color priorityMedium = Color(0xFFFFD54F);
  static const Color priorityLow = Color(0xFF81C784);

  // Error & Success
  static const Color errorColor = Color.fromARGB(255, 255, 7, 52);
  static const Color successColor = Color(0xFF388E3C);

  // Elevation
  static const double defaultElevation = 1.0;
  static const double cardElevation = 2.0;

  // Radius
  static const double borderRadius = 12.0;
  static const BorderRadius defaultBorderRadius = BorderRadius.all(
    Radius.circular(borderRadius),
  );

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        tertiary: secondaryAccentColor,
        background: lightBackgroundColor,
        error: errorColor,
        surface: cardColorLight,
      ),
      scaffoldBackgroundColor: lightBackgroundColor,
      cardTheme: CardTheme(
        color: cardColorLight,
        elevation: cardElevation,
        shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      appBarTheme: AppBarTheme(
        elevation: defaultElevation,
        backgroundColor: primaryColor,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunitoSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      textTheme: GoogleFonts.nunitoSansTextTheme().copyWith(
        titleLarge: GoogleFonts.nunitoSans(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimaryLight,
        ),
        titleMedium: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
        ),
        bodyLarge: GoogleFonts.nunitoSans(
          fontSize: 16,
          color: textPrimaryLight,
        ),
        bodyMedium: GoogleFonts.nunitoSans(
          fontSize: 14,
          color: textSecondaryLight,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: defaultBorderRadius,
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: defaultBorderRadius,
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: defaultBorderRadius,
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
          elevation: defaultElevation,
          textStyle: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.nunitoSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        elevation: cardElevation,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return secondaryAccentColor; // Blue checkmark color
          }
          return Colors.grey.shade400;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      dividerTheme: DividerThemeData(color: Colors.grey.shade300, thickness: 1),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        tertiary: secondaryAccentColor,
        background: darkBackgroundColor,
        error: errorColor,
        surface: cardColorDark,
      ),
      scaffoldBackgroundColor: darkBackgroundColor,
      cardTheme: CardTheme(
        color: cardColorDark,
        elevation: cardElevation,
        shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      appBarTheme: AppBarTheme(
        elevation: defaultElevation,
        backgroundColor: Color(0xFF1E1E1E),
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunitoSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      textTheme: GoogleFonts.nunitoSansTextTheme().copyWith(
        titleLarge: GoogleFonts.nunitoSans(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimaryDark,
        ),
        titleMedium: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimaryDark,
        ),
        bodyLarge: GoogleFonts.nunitoSans(fontSize: 16, color: textPrimaryDark),
        bodyMedium: GoogleFonts.nunitoSans(
          fontSize: 14,
          color: textSecondaryDark,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF424242),
        border: OutlineInputBorder(
          borderRadius: defaultBorderRadius,
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: defaultBorderRadius,
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: defaultBorderRadius,
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
          elevation: defaultElevation,
          textStyle: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.nunitoSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.black,
        elevation: cardElevation,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return secondaryAccentColor; // Blue checkmark color
          }
          return Colors.grey.shade700;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      dividerTheme: DividerThemeData(color: Colors.grey.shade700, thickness: 1),
    );
  }

  // Get Priority Color
  static Color getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return priorityHigh;
      case 'medium':
        return priorityMedium;
      default:
        return priorityLow;
    }
  }
}
