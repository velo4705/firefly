import 'package:firefly/domain/entities/search_result.dart';
import 'package:firefly/domain/repositories/search_repository.dart';

abstract class SearchAlbumsUseCase {
  Future<List<SearchResult>> call(String query);
}

class SearchAlbumsUseCaseImpl implements SearchAlbumsUseCase {
  final SearchRepository repository;
  SearchAlbumsUseCaseImpl(this.repository);
  @override
  Future<List<SearchResult>> call(String query) async {
    return repository.searchAlbums(query);
  }
}

abstract class SearchArtistsUseCase {
  Future<List<SearchResult>> call(String query);
}

class SearchArtistsUseCaseImpl implements SearchArtistsUseCase {
  final SearchRepository repository;
  SearchArtistsUseCaseImpl(this.repository);
  @override
  Future<List<SearchResult>> call(String query) async {
    return repository.searchArtists(query);
  }
}

abstract class SearchPlaylistsUseCase {
  Future<List<SearchResult>> call(String query);
}

class SearchPlaylistsUseCaseImpl implements SearchPlaylistsUseCase {
  final SearchRepository repository;
  SearchPlaylistsUseCaseImpl(this.repository);
  @override
  Future<List<SearchResult>> call(String query) async {
    return repository.searchPlaylists(query);
  }
}

abstract class GetTrendingUseCase {
  Future<List<SearchResult>> call();
}

class GetTrendingUseCaseImpl implements GetTrendingUseCase {
  final SearchRepository repository;
  GetTrendingUseCaseImpl(this.repository);
  @override
  Future<List<SearchResult>> call() async {
    return repository.getTrending();
  }
}

abstract class GetRecommendationsUseCase {
  Future<List<SearchResult>> call({
    List<String>? seedTracks,
    List<String>? seedArtists,
    List<String>? seedGenres,
    int limit,
  });
}

class GetRecommendationsUseCaseImpl implements GetRecommendationsUseCase {
  final SearchRepository repository;
  GetRecommendationsUseCaseImpl(this.repository);
  @override
  Future<List<SearchResult>> call({
    List<String>? seedTracks,
    List<String>? seedArtists,
    List<String>? seedGenres,
    int limit = 20,
  }) async {
    return repository.getRecommendations(
      seedTracks: seedTracks,
      seedArtists: seedArtists,
      seedGenres: seedGenres,
      limit: limit,
    );
  }
}

abstract class GetTrackDetailsUseCase {
  Future<SearchResult?> call(String trackId, String service);
}

class GetTrackDetailsUseCaseImpl implements GetTrackDetailsUseCase {
  final SearchRepository repository;
  GetTrackDetailsUseCaseImpl(this.repository);
  @override
  Future<SearchResult?> call(String trackId, String service) async {
    return repository.getTrackDetails(trackId, service);
  }
}
