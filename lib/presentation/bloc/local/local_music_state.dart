part of 'local_music_bloc.dart';

abstract class LocalMusicState {}

class LocalMusicInitial extends LocalMusicState {}

class LocalMusicLoading extends LocalMusicState {}

class LocalMusicScanning extends LocalMusicState {}

class LocalMusicLoaded extends LocalMusicState {
  final List<Track> tracks;

  LocalMusicLoaded({required this.tracks});
}

class LocalMusicScanSuccess extends LocalMusicState {
  final List<Track> tracks;

  LocalMusicScanSuccess({required this.tracks});
}

class LocalMusicScanFailure extends LocalMusicState {
  final String error;

  LocalMusicScanFailure({required this.error});
}

class LocalMusicFailure extends LocalMusicState {
  final String error;

  LocalMusicFailure({required this.error});
}

class TrackSelected extends LocalMusicState {
  final Track track;

  TrackSelected({required this.track});
}

class TrackPlaying extends LocalMusicState {
  final Track track;

  TrackPlaying({required this.track});
}

class TrackPaused extends LocalMusicState {
  final Track track;

  TrackPaused({required this.track});
}
