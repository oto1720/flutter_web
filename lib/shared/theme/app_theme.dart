import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2D6CDF),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.notoSansJpTextTheme(),
        useMaterial3: true,
      );
}
