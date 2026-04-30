import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:firefly/domain/entities/track.dart';

class YouTubeMusicApi {
  static const String _baseUrl = 'https://music.youtube.com';
  static const String _apiUrl = 'https://music.youtube.com/youtubei/v1';
  
  final Dio _dio = Dio();
  String? _apiKey;
  String? _authorizationToken;
  String? _visitorData;
  
  // Headers for YouTube Music API
  final Map<String, String> _defaultHeaders = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
    'Accept': '*/*',
    'Accept-Language': 'en-US,en;q=0.9',
    'Content-Type': 'application/json',
    'Origin': 'https://music.youtube.com',
    'Referer': 'https://music.youtube.com/',
    'X-Goog-Api-Format-Version': '1',
  };

  /// Initialize YouTube Music API
  Future<void> initialize() async {
    // In production, implement proper authentication flow
    // For demo purposes, use API in browse mode
    _apiKey = 'AIzaSyC9XL3ZjWddXya6X74kJy35Ll7v2r8s0yI'; // Demo key
  }

  /// Search for tracks, albums, artists, or playlists
  Future<Map<String, dynamic>> search(
    String query, {
    String type = 'song', // song, album, artist, playlist, video
    int limit = 25,
  }) async {
    try {
      final requestBody = {
        'context': _getContext(),
        'query': query,
        'params': _getSearchParams(type),
      };

      final response = await _dio.post(
        '$_apiUrl/search',
        queryParameters: {
          'key': _apiKey,
          'alt': 'json',
        },
        data: requestBody,
        options: Options(
          headers: _defaultHeaders,
        ),
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception('YouTube Music search failed: ${e.message}');
    }
  }

  /// Get song details by video ID
  Future<Map<String, dynamic>> getSong(String videoId) async {
    try {
      final requestBody = {
        'context': _getContext(),
        'videoId': videoId,
      };

      final response = await _dio.post(
        '$_apiUrl/player',
        queryParameters: {
          'key': _apiKey,
          'alt': 'json',
        },
        data: requestBody,
        options: Options(
          headers: _defaultHeaders,
        ),
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get song: ${e.message}');
    }
  }

  /// Get album details
  Future<Map<String, dynamic>> getAlbum(String browseId) async {
    try {
      final requestBody = {
        'context': _getContext(),
        'browseId': browseId,
      };

      final response = await _dio.post(
        '$_apiUrl/browse',
        queryParameters: {
          'key': _apiKey,
          'alt': 'json',
        },
        data: requestBody,
        options: Options(
          headers: _defaultHeaders,
        ),
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get album: ${e.message}');
    }
  }

  /// Get artist details
  Future<Map<String, dynamic>> getArtist(String browseId) async {
    try {
      final requestBody = {
        'context': _getContext(),
        'browseId': browseId,
      };

      final response = await _dio.post(
        '$_apiUrl/browse',
        queryParameters: {
          'key': _apiKey,
          'alt': 'json',
        },
        data: requestBody,
        options: Options(
          headers: _defaultHeaders,
        ),
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get artist: ${e.message}');
    }
  }

  /// Get recommendations / homepage
  Future<Map<String, dynamic>> getHomepage() async {
    try {
      final requestBody = {
        'context': _getContext(),
      };

      final response = await _dio.post(
        '$_apiUrl/browse',
        queryParameters: {
          'key': _apiKey,
          'alt': 'json',
          'browseId': 'FEmusic_home',
        },
        data: requestBody,
        options: Options(
          headers: _defaultHeaders,
        ),
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get homepage: ${e.message}');
    }
  }

  /// Get trending songs
  Future<Map<String, dynamic>> getTrending() async {
    try {
      final requestBody = {
        'context': _getContext(),
      };

      final response = await _dio.post(
        '$_apiUrl/browse',
        queryParameters: {
          'key': _apiKey,
          'alt': 'json',
          'browseId': 'FEmusic_moods_and_genres_category',
        },
        data: requestBody,
        options: Options(
          headers: _defaultHeaders,
        ),
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get trending: ${e.message}');
    }
  }

  /// Get lyrics for a song
  Future<String?> getLyrics(String browseId) async {
    try {
      final requestBody = {
        'context': _getContext(),
        'browseId': browseId,
      };

      final response = await _dio.post(
        '$_apiUrl/browse',
        queryParameters: {
          'key': _apiKey,
          'alt': 'json',
        },
        data: requestBody,
        options: Options(
          headers: _defaultHeaders,
        ),
      );

      final sections = response.data['contents']?['singleColumnBrowseResultsRenderer']
          ?['tabs']?[0]?['tabRenderer']?['content']?['sectionListRenderer']
          ?['contents'];

      if (sections != null && sections.isNotEmpty) {
        for (var section in sections) {
          final lyricSection = section['musicDescriptionShelfRenderer'];
          if (lyricSection != null) {
            final description = lyricSection['description']?['runs']?[0]?['text'];
            if (description != null) {
              return description;
            }
          }
        }
      }

      return null;
    } catch (e) {
      print('Error getting lyrics: $e');
      return null;
    }
  }

  /// Get related content (songs, playlists, artists)
  Future<Map<String, dynamic>> getRelated(
    String browseId, {
    String type = 'song',
  }) async {
    try {
      final requestBody = {
        'context': _getContext(),
        'browseId': browseId,
      };

      final response = await _dio.post(
        '$_apiUrl/browse',
        queryParameters: {
          'key': _apiKey,
          'alt': 'json',
        },
        data: requestBody,
        options: Options(
          headers: _defaultHeaders,
        ),
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get related content: ${e.message}');
    }
  }

  /// Build context for API requests
  Map<String, dynamic> _getContext() {
    return {
      'client': {
        'hl': 'en',
        'gl': 'US',
        'clientName': 'WEB_REMIX',
        'clientVersion': '1.20220606.00.00',
      },
      'user': {
        'enableSafetyMode': false,
      },
      'request': {
        'useSsl': true,
      },
    };
  }

  /// Build search parameters
  Map<String, dynamic> _getSearchParams(String type) {
    switch (type) {
      case 'song':
        return {'params': 'EgWKAQIIAWoKEAkQBRAKEAMQBA%3D%3D'};
      case 'video':
        return {'params': 'EgWKAQIQAw%3D%3D'};
      case 'album':
        return {'params': 'EgWKAQIYARgCIg%3D%3D'};
      case 'artist':
        return {'params': 'EgWKAQIgAw%3D%3D'};
      case 'playlist':
        return {'params': 'EgWKAQIgBxgCIg%3D%3D'};
      default:
        return {'params': 'EgWKAQIIAWoKEAkQBRAKEAMQBA%3D%3D'};
    }
  }

  /// Extract video ID from YouTube URL
  String? extractVideoId(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.host.contains('youtube.com') && uri.queryParameters.containsKey('v')) {
        return uri.queryParameters['v'];
      } else if (uri.host.contains('youtu.be')) {
        return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
      }
    } catch (e) {
      print('Error extracting video ID: $e');
    }
    return null;
  }

  /// Convert YouTube search result to Track entity
  Track? convertToTrack(Map<String, dynamic> item) {
    try {
      final videoRenderer = item['videoRenderer'] ?? item['musicResponsiveListItemRenderer'];
      if (videoRenderer == null) return null;

      final title = videoRenderer['title']?['runs']?[0]?['text'] ?? 'Unknown Title';

      final runs = videoRenderer['longBylineText']?['runs'] ?? [];
      final artists = <String>[];
      for (var run in runs) {
        if (run['text'] != null && run['text'] != ' • ') {
          artists.add(run['text']);
        }
      }
      final artist = artists.join(', ');

      final durationText = videoRenderer['lengthText']?['simpleText'] ??
          videoRenderer['musicResponsiveListItemFlexColumnRenderer']
              ?['text']?['runs']?[0]?['text'] ??
          '0:00';

      final durationParts = durationText.split(':').map((s) => int.tryParse(s) ?? 0).toList();
      Duration duration;
      if (durationParts.length == 3) {
        duration = Duration(hours: durationParts[0], minutes: durationParts[1], seconds: durationParts[2]);
      } else {
        duration = Duration(minutes: durationParts[0], seconds: durationParts.length > 1 ? durationParts[1] : 0);
      }

      final videoId = videoRenderer['videoId'] ??
          videoRenderer['overlay']?['musicItemThumbnailOverlayRenderer']?['content']
              ?['musicPlayButtonRenderer']?['playNavigationEndpoint']?['watchEndpoint']?['videoId'];

      return Track(
        id: videoId != null ? 'youtube_$videoId' : 'youtube_temp_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        artist: artist.isNotEmpty ? artist : 'Unknown Artist',
        album: 'YouTube Music',
        filePath: '',
        duration: duration,
        fileSize: 0,
        createdAt: DateTime.now(),
        genre: '',
        bitrate: 128,
        sampleRate: 44100,
        channels: 2,
      );
    } catch (e) {
      print('Error converting YouTube track: $e');
      return null;
    }
  }

  /// Convert YouTube album to Track list
  List<Track> convertAlbumToTracks(Map<String, dynamic> albumData) {
    final tracks = <Track>[];
    final contents = albumData['contents']?['singleColumnBrowseResultsRenderer']
        ?['tabs']?[0]?['tabRenderer']?['content']?['sectionListRenderer']
        ?['contents'];

    if (contents != null) {
      for (var content in contents) {
        final musicPlaylist = content['musicPlaylistShelfRenderer'];
        if (musicPlaylist != null) {
          final items = musicPlaylist['contents'] ?? [];
          for (var item in items) {
            final track = convertToTrack(item);
            if (track != null) {
              tracks.add(track);
            }
          }
          break;
        }
      }
    }

    return tracks;
  }

  /// Check if API is ready
  bool get isInitialized => _apiKey != null;
}
