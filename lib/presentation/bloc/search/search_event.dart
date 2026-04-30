part of 'search_bloc.dart';

abstract class SearchEvent {}

class SearchTracksEvent extends SearchEvent {
  final String query;

  SearchTracksEvent(this.query);
}

class SearchAlbumsEvent extends SearchEvent {
  final String query;

  SearchAlbumsEvent(this.query);
}

class SearchArtistsEvent extends SearchEvent {
  final String query;

  SearchArtistsEvent(this.query);
}

class SearchPlaylistsEvent extends SearchEvent {
  final String query;

  SearchPlaylistsEvent(this.query);
}

class GetRecommendationsEvent extends SearchEvent {
  final List<String>? seedTracks;
  final List<String>? seedArtists;
  final List<String>? seedGenres;
  final int limit;

  GetRecommendationsEvent({
    this.seedTracks,
    this.seedArtists,
    this.seedGenres,
    this.limit = 20,
  });
}

class GetTrendingEvent extends SearchEvent {}

class ClearSearchEvent extends SearchEvent {}
