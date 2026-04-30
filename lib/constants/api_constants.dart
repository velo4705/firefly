class ApiConstants {
  // API Keys - Replace with actual keys in production
  static const String spotifyClientId = 'YOUR_SPOTIFY_CLIENT_ID';
  static const String spotifyClientSecret = 'YOUR_SPOTIFY_CLIENT_SECRET';
  static const String youtubeApiKey = 'AIzaSyC9XL3ZjWddXya6X74kJy35Ll7v2r8s0yI';

  // API URLs
  static const String spotifyBaseUrl = 'https://api.spotify.com/v1';
  static const String spotifyAuthUrl = 'https://accounts.spotify.com/api/token';
  static const String youtubeBaseUrl = 'https://music.youtube.com';
  static const String youtubeApiUrl = 'https://music.youtube.com/youtubei/v1';

  // Request limits
  static const int maxSearchResults = 50;
  static const int defaultSearchLimit = 20;
  static const int defaultRecommendationsLimit = 20;

  // Cache durations
  static const Duration searchCacheDuration = Duration(minutes: 30);
  static const Duration recommendationsCacheDuration = Duration(hours: 1);
  static const Duration metadataCacheDuration = Duration(days: 7);
}
