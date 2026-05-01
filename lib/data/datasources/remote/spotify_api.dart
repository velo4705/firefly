import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firefly/domain/entities/track.dart';

class SpotifyApi {
  static const String _clientId = 'YOUR_SPOTIFY_CLIENT_ID';
  static const String _clientSecret = 'YOUR_SPOTIFY_CLIENT_SECRET';
  static const String _baseUrl = 'https://api.spotify.com/v1';
  static const String _authUrl = 'https://accounts.spotify.com/api/token';

  final Dio _dio = Dio();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? _accessToken;
  DateTime? _tokenExpiry;

  /// Initialize Spotify API with secure token storage
  Future<void> initialize() async {
    _accessToken = await _secureStorage.read(key: 'spotify_access_token');
    final expiryString = await _secureStorage.read(key: 'spotify_token_expiry');
    if (expiryString != null) {
      _tokenExpiry = DateTime.tryParse(expiryString);
    }
  }

  /// Authenticate with Spotify using Client Credentials flow
  Future<String> authenticate() async {
    try {
      // Check if token is still valid
      if (_accessToken != null && _tokenExpiry != null &&
          DateTime.now().isBefore(_tokenExpiry!)) {
        return _accessToken!;
      }

      // For demo purposes, return a mock token
      // In production, implement full OAuth2 flow
      _accessToken = 'demo_spotify_token';
      _tokenExpiry = DateTime.now().add(const Duration(hours: 1));
      
      await _secureStorage.write(key: 'spotify_access_token', value: _accessToken);
      await _secureStorage.write(
        key: 'spotify_token_expiry',
        value: _tokenExpiry!.toIso8601String(),
      );

      return _accessToken!;
    } catch (e) {
      throw Exception('Spotify authentication failed: $e');
    }
  }

  /// Search for tracks, albums, or artists
  Future<Map<String, dynamic>> search(
    String query, {
    String type = 'track',
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final token = await authenticate();
      final response = await _dio.get(
        '$_baseUrl/search',
        queryParameters: {
          'q': query,
          'type': type,
          'limit': limit,
          'offset': offset,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Token expired, refresh and retry
        await authenticate();
        return search(query, type: type, limit: limit, offset: offset);
      }
      throw Exception('Spotify search failed: ${e.message}');
    }
  }

  /// Get track details by ID
  Future<Map<String, dynamic>> getTrack(String trackId) async {
    try {
      final token = await authenticate();
      final response = await _dio.get(
        '$_baseUrl/tracks/$trackId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await authenticate();
        return getTrack(trackId);
      }
      throw Exception('Failed to get track: ${e.message}');
    }
  }

  /// Get album details
  Future<Map<String, dynamic>> getAlbum(String albumId) async {
    try {
      final token = await authenticate();
      final response = await _dio.get(
        '$_baseUrl/albums/$albumId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await authenticate();
        return getAlbum(albumId);
      }
      throw Exception('Failed to get album: ${e.message}');
    }
  }

  /// Get artist details
  Future<Map<String, dynamic>> getArtist(String artistId) async {
    try {
      final token = await authenticate();
      final response = await _dio.get(
        '$_baseUrl/artists/$artistId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await authenticate();
        return getArtist(artistId);
      }
      throw Exception('Failed to get artist: ${e.message}');
    }
  }

  /// Get track preview URL
  Future<String?> getTrackPreview(String trackId) async {
    try {
      final trackData = await getTrack(trackId);
      return trackData['preview_url'];
    } catch (e) {
      print('Error getting track preview: $e');
      return null;
    }
  }

  /// Get recommendations based on seed tracks
  Future<Map<String, dynamic>> getRecommendations({
    List<String>? seedTracks,
    List<String>? seedArtists,
    List<String>? seedGenres,
    int limit = 20,
  }) async {
    try {
      final token = await authenticate();
      final response = await _dio.get(
        '$_baseUrl/recommendations',
        queryParameters: {
          if (seedTracks != null && seedTracks.isNotEmpty)
            'seed_tracks': seedTracks.join(','),
          if (seedArtists != null && seedArtists.isNotEmpty)
            'seed_artists': seedArtists.join(','),
          if (seedGenres != null && seedGenres.isNotEmpty)
            'seed_genres': seedGenres.join(','),
          'limit': limit,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await authenticate();
        return getRecommendations(
          seedTracks: seedTracks,
          seedArtists: seedArtists,
          seedGenres: seedGenres,
          limit: limit,
        );
      }
      throw Exception('Failed to get recommendations: ${e.message}');
    }
  }

  /// Convert Spotify track to Firefly Track entity
  Track convertToTrack(Map<String, dynamic> spotifyTrack) {
    final artists = spotifyTrack['artists'] as List<dynamic>;
    final artistNames = artists.map((a) => a['name'] as String).join(', ');

    final album = spotifyTrack['album'] as Map<String, dynamic>;
    final images = album['images'] as List<dynamic>;
    final coverArt = images.isNotEmpty ? images[0]['url'] as String : '';

    return Track(
      id: 'spotify_${spotifyTrack['id']}',
      title: spotifyTrack['name'] ?? 'Unknown Title',
      artist: artistNames,
      album: album['name'] ?? 'Unknown Album',
      filePath: '',
      duration: Duration(milliseconds: spotifyTrack['duration_ms'] ?? 0),
      fileSize: 0,
      createdAt: DateTime.now(),
      genre: '',
      bitrate: 128,
      sampleRate: 44100,
      channels: 2,
    );
  }

  /// Convert Spotify album to Track list
  List<Track> convertAlbumToTracks(Map<String, dynamic> spotifyAlbum) {
    final tracks = spotifyAlbum['tracks']['items'] as List<dynamic>;
    final albumName = spotifyAlbum['name'] ?? 'Unknown Album';
    final artists = spotifyAlbum['artists'] as List<dynamic>;
    final artistNames = artists.map((a) => a['name'] as String).join(', ');

    return tracks.map((track) {
      final trackArtists = track['artists'] as List<dynamic>;
      final trackArtistNames = trackArtists.map((a) => a['name'] as String).join(', ');

      return Track(
        id: 'spotify_${track['id']}',
        title: track['name'] ?? 'Unknown Track',
        artist: trackArtistNames.isNotEmpty ? trackArtistNames : artistNames,
        album: albumName,
        filePath: '',
        duration: Duration(milliseconds: track['duration_ms'] ?? 0),
        fileSize: 0,
        createdAt: DateTime.now(),
        genre: '',
        bitrate: 128,
        sampleRate: 44100,
        channels: 2,
      );
    }).toList();
  }

  /// Check if authenticated
  bool get isAuthenticated =>
      _accessToken != null &&
      _tokenExpiry != null &&
      DateTime.now().isBefore(_tokenExpiry!);

  /// Clear authentication (logout)
  Future<void> logout() async {
    _accessToken = null;
    _tokenExpiry = null;
    await _secureStorage.delete(key: 'spotify_access_token');
    await _secureStorage.delete(key: 'spotify_token_expiry');
  }
}
