class AppConstants {
  AppConstants._();

  static const String appName = 'Firefly';
  static const String appVersion = '1.0.0';

  // API Constants
  static const String spotifyBaseUrl = 'https://api.spotify.com/v1';
  static const String youtubeMusicBaseUrl =
      'https://music.youtube.com/youtubei/v1';

  // Storage Constants
  static const String databaseName = 'firefly.db';
  static const String settingsBox = 'settings';
  static const String cacheBox = 'cache';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;

  // Animation Constants
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
}
