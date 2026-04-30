import 'package:firefly/data/datasources/remote/spotify_api.dart';
import 'package:firefly/data/datasources/remote/youtube_music_api.dart';
import 'package:firefly/domain/entities/search_result.dart';

abstract class SearchRepository {
  /// Search for tracks across all connected services
  Future<List<SearchResult>> searchTracks(String query);

  /// Search for albums
  Future<List<SearchResult>> searchAlbums(String query);

  /// Search for artists
  Future<List<SearchResult>> searchArtists(String query);

  /// Search for playlists
  Future<List<SearchResult>> searchPlaylists(String query);

  /// Get track details from a specific service
  Future<SearchResult?> getTrackDetails(String trackId, String service);

  /// Get album details from a specific service
  Future<SearchResult?> getAlbumDetails(String albumId, String service);

  /// Get artist details from a specific service
  Future<SearchResult?> getArtistDetails(String artistId, String service);

  /// Get recommendations based on seed tracks
  Future<List<SearchResult>> getRecommendations({
    List<String>? seedTracks,
    List<String>? seedArtists,
    List<String>? seedGenres,
    int limit = 20,
  });

  /// Get trending songs
  Future<List<SearchResult>> getTrending();

  /// Clear search cache
  Future<void> clearCache();
}

class SearchRepositoryImpl implements SearchRepository {
  final SpotifyApi _spotifyApi;
  final YouTubeMusicApi _youtubeMusicApi;

  SearchRepositoryImpl({
    required SpotifyApi spotifyApi,
    required YouTubeMusicApi youtubeMusicApi,
  })  : _spotifyApi = spotifyApi,
        _youtubeMusicApi = youtubeMusicApi;

  @override
  Future<List<SearchResult>> searchTracks(String query) async {
    final results = <SearchResult>[];

    try {
      // Search Spotify if authenticated
      if (_spotifyApi.isAuthenticated) {
        final spotifyResults = await _spotifyApi.search(query, type: 'track');
        final tracks = spotifyResults['tracks']?['items'] ?? [];

        for (var track in tracks) {
          results.add(_convertSpotifyTrack(track));
        }
      }

      // Search YouTube Music
      final youtubeResults = await _youtubeMusicApi.search(query, type: 'song');
      final items = youtubeResults['contents']?['sectionListRenderer']
          ?['contents'] ?? [];

      for (var section in items) {
        final musicShelf = section['musicShelfRenderer'];
        if (musicShelf != null) {
          final contents = musicShelf['contents'] ?? [];
          for (var item in contents) {
            final track = _youtubeMusicApi.convertToTrack(item);
            if (track != null) {
              results.add(SearchResult.fromTrack(track, 'youtube'));
            }
          }
        }
      }
    } catch (e) {
      print('Search failed: $e');
    }

    // Remove duplicates based on title and artist similarity
    return _removeDuplicates(results);
  }

  @override
  Future<List<SearchResult>> searchAlbums(String query) async {
    final results = <SearchResult>[];

    try {
      if (_spotifyApi.isAuthenticated) {
        final spotifyResults = await _spotifyApi.search(query, type: 'album');
        final albums = spotifyResults['albums']?['items'] ?? [];

        for (var album in albums) {
          results.add(_convertSpotifyAlbum(album));
        }
      }

      final youtubeResults = await _youtubeMusicApi.search(query, type: 'album');
      final items = youtubeResults['contents']?['sectionListRenderer']
          ?['contents'] ?? [];

      for (var section in items) {
        final shelf = section['musicShelfRenderer'];
        if (shelf != null) {
          final contents = shelf['contents'] ?? [];
          for (var item in contents) {
            final album = item['musicTwoRowItemRenderer'];
            if (album != null) {
              final title = album['title']?['runs']?[0]?['text'] ?? '';
              final subtitle = album['subtitle']?['runs']?[0]?['text'] ?? '';
              final browseId = album['navigationEndpoint']
                  ?['browseEndpoint']?['browseId'] ?? '';

              if (title.isNotEmpty) {
                results.add(SearchResult(
                  id: 'youtube_album_$browseId',
                  title: title,
                  artist: subtitle,
                  type: 'album',
                  service: 'youtube',
                  coverArt: album['thumbnail']?['musicThumbnailRenderer']
                      ?['thumbnail']['thumbnails']?[0]?['url'] ?? '',
                ));
              }
            }
          }
        }
      }
    } catch (e) {
      print('Album search failed: $e');
    }

    return results;
  }

  @override
  Future<List<SearchResult>> searchArtists(String query) async {
    final results = <SearchResult>[];

    try {
      if (_spotifyApi.isAuthenticated) {
        final spotifyResults = await _spotifyApi.search(query, type: 'artist');
        final artists = spotifyResults['artists']?['items'] ?? [];

        for (var artist in artists) {
          results.add(_convertSpotifyArtist(artist));
        }
      }

      final youtubeResults = await _youtubeMusicApi.search(query, type: 'artist');
      final items = youtubeResults['contents']?['sectionListRenderer']
          ?['contents'] ?? [];

      for (var section in items) {
        final shelf = section['musicShelfRenderer'];
        if (shelf != null) {
          final contents = shelf['contents'] ?? [];
          for (var item in contents) {
            final artist = item['musicTwoRowItemRenderer'];
            if (artist != null) {
              final title = artist['title']?['runs']?[0]?['text'] ?? '';
              final browseId = artist['navigationEndpoint']
                  ?['browseEndpoint']?['browseId'] ?? '';

              if (title.isNotEmpty) {
                results.add(SearchResult(
                  id: 'youtube_artist_$browseId',
                  title: title,
                  artist: '',
                  type: 'artist',
                  service: 'youtube',
                  coverArt: artist['thumbnail']?['musicThumbnailRenderer']
                      ?['thumbnail']['thumbnails']?[0]?['url'] ?? '',
                ));
              }
            }
          }
        }
      }
    } catch (e) {
      print('Artist search failed: $e');
    }

    return results;
  }

  @override
  Future<List<SearchResult>> searchPlaylists(String query) async {
    final results = <SearchResult>[];

    try {
      if (_spotifyApi.isAuthenticated) {
        final spotifyResults = await _spotifyApi.search(query, type: 'playlist');
        final playlists = spotifyResults['playlists']?['items'] ?? [];

        for (var playlist in playlists) {
          results.add(_convertSpotifyPlaylist(playlist));
        }
      }

      final youtubeResults = await _youtubeMusicApi.search(query, type: 'playlist');
      final items = youtubeResults['contents']?['sectionListRenderer']
          ?['contents'] ?? [];

      for (var section in items) {
        final shelf = section['musicShelfRenderer'];
        if (shelf != null) {
          final contents = shelf['contents'] ?? [];
          for (var item in contents) {
            final playlist = item['musicTwoRowItemRenderer'];
            if (playlist != null) {
              final title = playlist['title']?['runs']?[0]?['text'] ?? '';
              final subtitle = playlist['subtitle']?['runs']?[0]?['text'] ?? '';
              final browseId = playlist['navigationEndpoint']
                  ?['browseEndpoint']?['browseId'] ?? '';

              if (title.isNotEmpty) {
                results.add(SearchResult(
                  id: 'youtube_playlist_$browseId',
                  title: title,
                  artist: subtitle,
                  type: 'playlist',
                  service: 'youtube',
                  coverArt: playlist['thumbnail']?['musicThumbnailRenderer']
                      ?['thumbnail']['thumbnails']?[0]?['url'] ?? '',
                ));
              }
            }
          }
        }
      }
    } catch (e) {
      print('Playlist search failed: $e');
    }

    return results;
  }

  @override
  Future<SearchResult?> getTrackDetails(String trackId, String service) async {
    try {
      if (service == 'spotify' && trackId.startsWith('spotify_')) {
        final spotifyId = trackId.replaceFirst('spotify_', '');
        final trackData = await _spotifyApi.getTrack(spotifyId);
        return _convertSpotifyTrack(trackData);
      } else if (service == 'youtube' && trackId.startsWith('youtube_')) {
        final videoId = trackId.replaceFirst('youtube_', '');
        final trackData = await _youtubeMusicApi.getSong(videoId);
        // Convert YouTube track data to SearchResult
        return SearchResult(
          id: trackId,
          title: trackData['videoDetails']?['title'] ?? '',
          artist: trackData['videoDetails']?['author'] ?? '',
          type: 'track',
          service: 'youtube',
        );
      }
    } catch (e) {
      print('Failed to get track details: $e');
    }
    return null;
  }

  @override
  Future<SearchResult?> getAlbumDetails(String albumId, String service) async {
    try {
      if (service == 'spotify' && albumId.startsWith('spotify_')) {
        final spotifyId = albumId.replaceFirst('spotify_', '');
        final albumData = await _spotifyApi.getAlbum(spotifyId);
        return _convertSpotifyAlbum(albumData);
      } else if (service == 'youtube') {
        final albumData = await _youtubeMusicApi.getAlbum(albumId);
        final title = albumData['header']?['musicDetailHeaderRenderer']
            ?['title']?['runs']?[0]?['text'] ?? '';

        return SearchResult(
          id: albumId,
          title: title,
          artist: '',
          type: 'album',
          service: 'youtube',
        );
      }
    } catch (e) {
      print('Failed to get album details: $e');
    }
    return null;
  }

  @override
  Future<SearchResult?> getArtistDetails(String artistId, String service) async {
    try {
      if (service == 'spotify' && artistId.startsWith('spotify_')) {
        final spotifyId = artistId.replaceFirst('spotify_', '');
        final artistData = await _spotifyApi.getArtist(spotifyId);
        return _convertSpotifyArtist(artistData);
      } else if (service == 'youtube') {
        final artistData = await _youtubeMusicApi.getArtist(artistId);
        final title = artistData['header']?['musicImmersiveHeaderRenderer']
            ?['title']?['runs']?[0]?['text'] ?? '';

        return SearchResult(
          id: artistId,
          title: title,
          artist: '',
          type: 'artist',
          service: 'youtube',
        );
      }
    } catch (e) {
      print('Failed to get artist details: $e');
    }
    return null;
  }

  @override
  Future<List<SearchResult>> getRecommendations({
    List<String>? seedTracks,
    List<String>? seedArtists,
    List<String>? seedGenres,
    int limit = 20,
  }) async {
    final results = <SearchResult>[];

    try {
      if (_spotifyApi.isAuthenticated && seedTracks != null && seedTracks.isNotEmpty) {
        final spotifyRecs = await _spotifyApi.getRecommendations(
          seedTracks: seedTracks.map((id) => id.replaceFirst('spotify_', '')).toList(),
          seedArtists: seedArtists?.map((id) => id.replaceFirst('spotify_', '')).toList(),
          seedGenres: seedGenres,
          limit: limit,
        );

        final tracks = spotifyRecs['tracks'] ?? [];
        for (var track in tracks) {
          results.add(_convertSpotifyTrack(track));
        }
      }
    } catch (e) {
      print('Recommendations failed: $e');
    }

    return results;
  }

  @override
  Future<List<SearchResult>> getTrending() async {
    final results = <SearchResult>[];

    try {
      final youtubeTrending = await _youtubeMusicApi.getTrending();
      // Parse trending results from YouTube Music
    } catch (e) {
      print('Trending fetch failed: $e');
    }

    return results;
  }

  @override
  Future<void> clearCache() async {
    // TODO: Implement cache clearing
  }

  SearchResult _convertSpotifyTrack(Map<String, dynamic> track) {
    final artists = track['artists'] as List<dynamic>;
    final artistNames = artists.map((a) => a['name'] as String).join(', ');

    final album = track['album'] as Map<String, dynamic>;
    final images = album['images'] as List<dynamic>;
    final coverArt = images.isNotEmpty ? images[0]['url'] as String : '';

    return SearchResult(
      id: 'spotify_${track['id']}',
      title: track['name'] ?? 'Unknown Track',
      artist: artistNames,
      type: 'track',
      service: 'spotify',
      coverArt: coverArt,
    );
  }

  SearchResult _convertSpotifyAlbum(Map<String, dynamic> album) {
    final artists = album['artists'] as List<dynamic>;
    final artistNames = artists.map((a) => a['name'] as String).join(', ');

    final images = album['images'] as List<dynamic>;
    final coverArt = images.isNotEmpty ? images[0]['url'] as String : '';

    return SearchResult(
      id: 'spotify_${album['id']}',
      title: album['name'] ?? 'Unknown Album',
      artist: artistNames,
      type: 'album',
      service: 'spotify',
      coverArt: coverArt,
    );
  }

  SearchResult _convertSpotifyArtist(Map<String, dynamic> artist) {
    final images = artist['images'] as List<dynamic>;
    final coverArt = images.isNotEmpty ? images[0]['url'] as String : '';

    return SearchResult(
      id: 'spotify_${artist['id']}',
      title: artist['name'] ?? 'Unknown Artist',
      artist: '',
      type: 'artist',
      service: 'spotify',
      coverArt: coverArt,
    );
  }

  SearchResult _convertSpotifyPlaylist(Map<String, dynamic> playlist) {
    final images = playlist['images'] as List<dynamic>;
    final coverArt = images.isNotEmpty ? images[0]['url'] as String : '';

    return SearchResult(
      id: 'spotify_${playlist['id']}',
      title: playlist['name'] ?? 'Unknown Playlist',
      artist: playlist['owner']?['display_name'] ?? 'Spotify',
      type: 'playlist',
      service: 'spotify',
      coverArt: coverArt,
    );
  }

  List<SearchResult> _removeDuplicates(List<SearchResult> results) {
    final seen = <String>{};
    final unique = <SearchResult>[];

    for (var result in results) {
      final key = '${result.title.toLowerCase()}_${result.artist.toLowerCase()}';
      if (!seen.contains(key)) {
        seen.add(key);
        unique.add(result);
      }
    }

    return unique;
  }
}
