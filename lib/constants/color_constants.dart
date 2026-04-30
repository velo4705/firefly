class ColorConstants {
  ColorConstants._();

  // Primary Firefly Colors
  static const int primaryYellow = 0xFFFFB300;
  static const int primaryOrange = 0xFFFF6F00;
  static const int deepOrange = 0xFFE65100;

  // Background Colors
  static const int darkBackground = 0xFF121212;
  static const int darkerBackground = 0xFF0D0D0D;
  static const int cardBackground = 0xFF1E1E1E;
  static const int surfaceBackground = 0xFF2A2A2A;

  // Text Colors
  static const int primaryText = 0xFFFFFFFF;
  static const int secondaryText = 0xFFB3B3B3;
  static const int disabledText = 0xFF666666;

  // Accent Colors
  static const int accentGreen = 0xFF00E676;
  static const int accentRed = 0xFFFF5252;
  static const int accentBlue = 0xFF448AFF;

  // Gradient Colors
  static const List<int> fireflyGradient = [
    primaryYellow,
    primaryOrange,
    deepOrange,
  ];

  // State Colors
  static const int playingColor = accentGreen;
  static const int pausedColor = secondaryText;
  static const int loadingColor = primaryYellow;
  static const int errorColor = accentRed;
}
