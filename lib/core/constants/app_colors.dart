import 'package:flutter/material.dart';

class AppColors {
  // Primary brand color used for key UI elements, such as buttons and headlines.
  static const Color primary = Color(0xFF951095);

  // A darker variant of the primary color, useful for pressed states or emphasis.
  static const Color primaryDark = Color(0xFF7E0E7E);

  // A lighter variant of the primary color that can be used as a background or for accents.
  // Here, it's the same as your 'surface' color.
  static const Color primaryLight = Color(0xFFF3E5F5);

  // Surface color used for cards, panels, or other elements that sit on top of the background.
  static const Color surface = Color(0xFFF3E5F5); // Light lavender surface

  // Background color for the main scaffold and overall app background.
  static const Color background = Color(0xFFFFFFFF); // Pure white or any light neutral tone

  // Primary text color for most content. (You can adjust if you prefer a dark gray over pure black)
  static const Color textPrimary = Color(0xFF212121);

  // Secondary text color for captions, subtitles, or less prominent text.
  static const Color textSecondary = Color(0xFF757575); // Neutral gray for secondary text

  // Error color used to indicate errors, warnings, or critical status.
  static const Color error = Color(0xFFE53935);

  // Warning color which can be used for alerts or cautionary messages.
  static const Color warning = Color(0xFFFFA726);

  // An accent color for highlighting interactive elements (such as icons or floating action buttons).
  static const Color accent = Color(0xFFFF4081);
}
