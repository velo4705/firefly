import 'package:firefly/domain/entities/search_result.dart';
import 'package:firefly/domain/repositories/search_repository.dart';

abstract class SearchTracksUseCase {
  Future<List<SearchResult>> call(String query);
}

class SearchTracksUseCaseImpl implements SearchTracksUseCase {
  final SearchRepository repository;
  SearchTracksUseCaseImpl(this.repository);
  @override
  Future<List<SearchResult>> call(String query) async {
    return repository.searchTracks(query);
  }
}
