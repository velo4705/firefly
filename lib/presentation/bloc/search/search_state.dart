part of 'search_bloc.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {
  final String? query;

  SearchLoading({this.query});
}

class SearchLoaded extends SearchState {
  final List<SearchResult> results;
  final String query;
  final String type; // tracks, albums, artists, playlists

  SearchLoaded({
    required this.results,
    required this.query,
    required this.type,
  });
}

class RecommendationsLoaded extends SearchState {
  final List<SearchResult> results;

  RecommendationsLoaded({required this.results});
}

class TrendingLoaded extends SearchState {
  final List<SearchResult> results;

  TrendingLoaded({required this.results});
}

class SearchError extends SearchState {
  final String error;
  final String? query;

  SearchError({
    required this.error,
    this.query,
  });
}
