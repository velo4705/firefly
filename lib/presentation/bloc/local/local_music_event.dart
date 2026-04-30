part of 'local_music_bloc.dart';

abstract class LocalMusicEvent {}

class ScanLocalMusicEvent extends LocalMusicEvent {
  final String directoryPath;

  ScanLocalMusicEvent(this.directoryPath);
}

class LoadLocalTracksEvent extends LocalMusicEvent {}

class SelectTrackEvent extends LocalMusicEvent {
  final Track track;

  SelectTrackEvent(this.track);
}

class PlayTrackEvent extends LocalMusicEvent {
  final Track track;

  PlayTrackEvent(this.track);
}

class PauseTrackEvent extends LocalMusicEvent {
  final Track track;

  PauseTrackEvent(this.track);
}

class SearchLocalTracksEvent extends LocalMusicEvent {
  final String query;

  SearchLocalTracksEvent(this.query);
}

class ToggleFavoriteEvent extends LocalMusicEvent {
  final String trackId;

  ToggleFavoriteEvent(this.trackId);
}
