import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firefly/domain/usecases/search/search_tracks_usecase.dart';
import 'package:firefly/domain/usecases/search/search_albums_usecase.dart';
import 'package:firefly/domain/entities/search_result.dart';
import 'package:firefly/domain/repositories/search_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchTracksUseCase _searchTracksUseCase;
  final SearchAlbumsUseCase _searchAlbumsUseCase;
  final SearchArtistsUseCase _searchArtistsUseCase;
  final SearchPlaylistsUseCase _searchPlaylistsUseCase;
  final GetRecommendationsUseCase _getRecommendationsUseCase;
  final GetTrendingUseCase _getTrendingUseCase;

  SearchBloc({
    required SearchRepository repository,
  })  : _searchTracksUseCase = SearchTracksUseCaseImpl(repository),
        _searchAlbumsUseCase = SearchAlbumsUseCaseImpl(repository),
        _searchArtistsUseCase = SearchArtistsUseCaseImpl(repository),
        _searchPlaylistsUseCase = SearchPlaylistsUseCaseImpl(repository),
        _getRecommendationsUseCase = GetRecommendationsUseCaseImpl(repository),
        _getTrendingUseCase = GetTrendingUseCaseImpl(repository),
        super(SearchInitial()) {
    on<SearchTracksEvent>(_onSearchTracks);
    on<SearchAlbumsEvent>(_onSearchAlbums);
    on<SearchArtistsEvent>(_onSearchArtists);
    on<SearchPlaylistsEvent>(_onSearchPlaylists);
    on<GetRecommendationsEvent>(_onGetRecommendations);
    on<GetTrendingEvent>(_onGetTrending);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onSearchTracks(
    SearchTracksEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading(query: event.query));

    try {
      final results = await _searchTracksUseCase(event.query);
      emit(SearchLoaded(
        results: results,
        query: event.query,
        type: 'tracks',
      ));
    } catch (e) {
      emit(SearchError(
        error: e.toString(),
        query: event.query,
      ));
    }
  }

  Future<void> _onSearchAlbums(
    SearchAlbumsEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading(query: event.query));

    try {
      final results = await _searchAlbumsUseCase(event.query);
      emit(SearchLoaded(
        results: results,
        query: event.query,
        type: 'albums',
      ));
    } catch (e) {
      emit(SearchError(
        error: e.toString(),
        query: event.query,
      ));
    }
  }

  Future<void> _onSearchArtists(
    SearchArtistsEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading(query: event.query));

    try {
      final results = await _searchArtistsUseCase(event.query);
      emit(SearchLoaded(
        results: results,
        query: event.query,
        type: 'artists',
      ));
    } catch (e) {
      emit(SearchError(
        error: e.toString(),
        query: event.query,
      ));
    }
  }

  Future<void> _onSearchPlaylists(
    SearchPlaylistsEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading(query: event.query));

    try {
      final results = await _searchPlaylistsUseCase(event.query);
      emit(SearchLoaded(
        results: results,
        query: event.query,
        type: 'playlists',
      ));
    } catch (e) {
      emit(SearchError(
        error: e.toString(),
        query: event.query,
      ));
    }
  }

  Future<void> _onGetRecommendations(
    GetRecommendationsEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());

    try {
      final results = await _getRecommendationsUseCase(
        seedTracks: event.seedTracks,
        seedArtists: event.seedArtists,
        seedGenres: event.seedGenres,
        limit: event.limit,
      );
      emit(RecommendationsLoaded(results: results));
    } catch (e) {
      emit(SearchError(error: e.toString()));
    }
  }

  Future<void> _onGetTrending(
    GetTrendingEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());

    try {
      final results = await _getTrendingUseCase();
      emit(TrendingLoaded(results: results));
    } catch (e) {
      emit(SearchError(error: e.toString()));
    }
  }

  void _onClearSearch(
    ClearSearchEvent event,
    Emitter<SearchState> emit,
  ) {
    emit(SearchInitial());
  }
}
