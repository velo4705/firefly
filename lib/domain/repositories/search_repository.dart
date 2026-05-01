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
  @override
  Future<List<SearchResult>> searchTracks(String query) async {
    return [];
  }

  @override
  Future<List<SearchResult>> searchAlbums(String query) async {
    return [];
  }

  @override
  Future<List<SearchResult>> searchArtists(String query) async {
    return [];
  }

  @override
  Future<List<SearchResult>> searchPlaylists(String query) async {
    return [];
  }

  @override
  Future<List<SearchResult>> getTrending() async {
    return [];
  }

  @override
  Future<List<SearchResult>> getRecommendations({
    List<String>? seedTracks,
    List<String>? seedArtists,
    List<String>? seedGenres,
    int limit = 20,
  }) async {
    return [];
  }

  @override
  Future<SearchResult?> getTrackDetails(String trackId, String service) async {
    return null;
  }

  @override
  Future<SearchResult?> getAlbumDetails(String albumId, String service) async {
    return null;
  }

  @override
  Future<SearchResult?> getArtistDetails(String artistId, String service) async {
    return null;
  }

  @override
  Future<void> clearCache() async {}
}
