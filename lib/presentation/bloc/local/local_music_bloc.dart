import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firefly/domain/usecases/local/scan_local_music_usecase.dart';
import 'package:firefly/domain/repositories/local_repository.dart';
import 'package:firefly/domain/entities/track.dart';

part 'local_music_event.dart';
part 'local_music_state.dart';

class LocalMusicBloc extends Bloc<LocalMusicEvent, LocalMusicState> {
  final ScanLocalMusicUsecase _scanLocalMusicUsecase;
  final LocalRepository _repository;

  LocalMusicBloc({
    required ScanLocalMusicUsecase scanLocalMusicUsecase,
    required LocalRepository repository,
  })  : _scanLocalMusicUsecase = scanLocalMusicUsecase,
        _repository = repository,
        super(LocalMusicInitial()) {
    on<ScanLocalMusicEvent>(_onScanLocalMusic);
    on<LoadLocalTracksEvent>(_onLoadLocalTracks);
    on<SelectTrackEvent>(_onSelectTrack);
    on<PlayTrackEvent>(_onPlayTrack);
    on<PauseTrackEvent>(_onPauseTrack);
    on<SearchLocalTracksEvent>(_onSearchLocalTracks);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onScanLocalMusic(
    ScanLocalMusicEvent event,
    Emitter<LocalMusicState> emit,
  ) async {
    emit(LocalMusicScanning());
    try {
      final tracks = await _scanLocalMusicUsecase(event.directoryPath);
      emit(LocalMusicScanSuccess(tracks: tracks));
    } catch (e) {
      emit(LocalMusicScanFailure(error: e.toString()));
    }
  }

  Future<void> _onLoadLocalTracks(
    LoadLocalTracksEvent event,
    Emitter<LocalMusicState> emit,
  ) async {
    emit(LocalMusicLoading());
    try {
      final tracks = await _repository.getLocalTracks();
      emit(LocalMusicLoaded(tracks: tracks));
    } catch (e) {
      emit(LocalMusicFailure(error: e.toString()));
    }
  }

  Future<void> _onSearchLocalTracks(
    SearchLocalTracksEvent event,
    Emitter<LocalMusicState> emit,
  ) async {
    try {
      final tracks = await _repository.searchTracks(event.query);
      emit(LocalMusicLoaded(tracks: tracks));
    } catch (e) {
      emit(LocalMusicFailure(error: e.toString()));
    }
  }

  void _onSelectTrack(
    SelectTrackEvent event,
    Emitter<LocalMusicState> emit,
  ) {
    emit(TrackSelected(track: event.track));
  }

  void _onPlayTrack(
    PlayTrackEvent event,
    Emitter<LocalMusicState> emit,
  ) {
    emit(TrackPlaying(track: event.track));
  }

  void _onPauseTrack(
    PauseTrackEvent event,
    Emitter<LocalMusicState> emit,
  ) {
    emit(TrackPaused(track: event.track));
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<LocalMusicState> emit,
  ) async {
    try {
      await _repository.toggleFavorite(event.trackId);
      final tracks = await _repository.getLocalTracks();
      emit(LocalMusicLoaded(tracks: tracks));
    } catch (e) {
      emit(LocalMusicFailure(error: e.toString()));
    }
  }
}
