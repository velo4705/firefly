import 'package:firefly/domain/repositories/search_repository.dart';
import 'package:firefly/domain/entities/search_result.dart';

class SearchTracksUseCase {
  final SearchRepository repository;

  SearchTracksUseCase(this.repository);

  Future<List<SearchResult>> call(String query) async {
    return await repository.searchTracks(query);
  }
}

class SearchAlbumsUseCase {
  final SearchRepository repository;

  SearchAlbumsUseCase(this.repository);

  Future<List<SearchResult>> call(String query) async {
    return await repository.searchAlbums(query);
  }
}

class SearchArtistsUseCase {
  final SearchRepository repository;

  SearchArtistsUseCase(this.repository);

  Future<List<SearchResult>> call(String query) async {
    return await repository.searchArtists(query);
  }
}

class SearchPlaylistsUseCase {
  final SearchRepository repository;

  SearchPlaylistsUseCase(this.repository);

  Future<List<SearchResult>> call(String query) async {
    return await repository.searchPlaylists(query);
  }
}

class GetRecommendationsUseCase {
  final SearchRepository repository;

  GetRecommendationsUseCase(this.repository);

  Future<List<SearchResult>> call({
    List<String>? seedTracks,
    List<String>? seedArtists,
    List<String>? seedGenres,
    int limit = 20,
  }) async {
    return await repository.getRecommendations(
      seedTracks: seedTracks,
      seedArtists: seedArtists,
      seedGenres: seedGenres,
      limit: limit,
    );
  }
}

class GetTrendingUseCase {
  final SearchRepository repository;

  GetTrendingUseCase(this.repository);

  Future<List<SearchResult>> call() async {
    return await repository.getTrending();
  }
}

class GetTrackDetailsUseCase {
  final SearchRepository repository;

  GetTrackDetailsUseCase(this.repository);

  Future<SearchResult?> call(String trackId, String service) async {
    return await repository.getTrackDetails(trackId, service);
  }
}
