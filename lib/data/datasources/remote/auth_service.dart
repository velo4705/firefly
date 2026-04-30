import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firefly/data/datasources/remote/spotify_api.dart';
import 'package:firefly/data/datasources/remote/youtube_music_api.dart';

enum AuthServiceType { spotify, youtubeMusic, both }

class AuthService {
  final SpotifyApi _spotifyApi = SpotifyApi();
  final YouTubeMusicApi _youtubeMusicApi = YouTubeMusicApi();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  bool _isSpotifyAuthenticated = false;
  bool _isYouTubeMusicAuthenticated = false;

  /// Initialize authentication service
  Future<void> initialize() async {
    await _spotifyApi.initialize();
    await _youtubeMusicApi.initialize();
    
    _isSpotifyAuthenticated = _spotifyApi.isAuthenticated;
    // YouTube Music API key is always available (no user auth required)
    _isYouTubeMusicAuthenticated = true;
  }

  /// Authenticate with Spotify
  Future<bool> authenticateWithSpotify() async {
    try {
      await _spotifyApi.authenticate();
      _isSpotifyAuthenticated = true;
      await _secureStorage.write(key: 'spotify_authenticated', value: 'true');
      return true;
    } catch (e) {
      print('Spotify authentication failed: $e');
      _isSpotifyAuthenticated = false;
      return false;
    }
  }

  /// Authenticate with YouTube Music (always returns true for API key)
  Future<bool> authenticateWithYouTubeMusic() async {
    try {
      await _youtubeMusicApi.initialize();
      _isYouTubeMusicAuthenticated = true;
      await _secureStorage.write(key: 'youtube_auth', value: 'true');
      return true;
    } catch (e) {
      print('YouTube Music authentication failed: $e');
      _isYouTubeMusicAuthenticated = false;
      return false;
    }
  }

  /// Authenticate with both services
  Future<Map<String, bool>> authenticateWithAll() async {
    final results = await Future.wait([
      authenticateWithSpotify(),
      authenticateWithYouTubeMusic(),
    ]);

    return {
      'spotify': results[0],
      'youtubeMusic': results[1],
    };
  }

  /// Logout from Spotify
  Future<void> logoutFromSpotify() async {
    await _spotifyApi.logout();
    _isSpotifyAuthenticated = false;
    await _secureStorage.delete(key: 'spotify_authenticated');
  }

  /// Logout from YouTube Music
  Future<void> logoutFromYouTubeMusic() async {
    _isYouTubeMusicAuthenticated = false;
    await _secureStorage.delete(key: 'youtube_auth');
  }

  /// Logout from all services
  Future<void> logoutFromAll() async {
    await Future.wait([
      logoutFromSpotify(),
      logoutFromYouTubeMusic(),
    ]);
  }

  /// Check if authenticated with a specific service
  bool isAuthenticatedWith(AuthServiceType type) {
    switch (type) {
      case AuthServiceType.spotify:
        return _isSpotifyAuthenticated;
      case AuthServiceType.youtubeMusic:
        return _isYouTubeMusicAuthenticated;
      case AuthServiceType.both:
        return _isSpotifyAuthenticated && _isYouTubeMusicAuthenticated;
    }
  }

  /// Get Spotify API instance
  SpotifyApi get spotifyApi => _spotifyApi;

  /// Get YouTube Music API instance
  YouTubeMusicApi get youtubeMusicApi => _youtubeMusicApi;

  /// Get all authenticated services
  List<AuthServiceType> get authenticatedServices {
    final services = <AuthServiceType>[];
    if (_isSpotifyAuthenticated) services.add(AuthServiceType.spotify);
    if (_isYouTubeMusicAuthenticated) services.add(AuthServiceType.youtubeMusic);
    return services;
  }

  /// Check if any service is authenticated
  bool get isAnyAuthenticated =>
      _isSpotifyAuthenticated || _isYouTubeMusicAuthenticated;

  /// Check if all services are authenticated
  bool get isAllAuthenticated =>
      _isSpotifyAuthenticated && _isYouTubeMusicAuthenticated;
}
