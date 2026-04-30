import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audio_session/audio_session.dart';
import 'package:firefly/domain/entities/track.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);

  // Streams for state
  final _currentTrackSubject = BehaviorSubject<Track?>();
  final _playerStateSubject = BehaviorSubject<PlayerState>();
  final _positionSubject = BehaviorSubject<Duration>();
  final _durationSubject = BehaviorSubject<Duration>();
  final _bufferedPositionSubject = BehaviorSubject<Duration>();
  final _volumeSubject = BehaviorSubject<double>.seeded(0.8);
  final _speedSubject = BehaviorSubject<double>.seeded(1.0);
  final _repeatModeSubject = BehaviorSubject<LoopMode>.seeded(LoopMode.off);
  final _shuffleModeSubject = BehaviorSubject<bool>.seeded(false);

  AudioPlayerService() {
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.allowBluetooth,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.media,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    // Listen to player state changes
    _player.playerStateStream.listen((state) {
      _playerStateSubject.add(state);
    });

    _player.positionStream.listen((position) {
      _positionSubject.add(position);
    });

    _player.durationStream.listen((duration) {
      _durationSubject.add(duration ?? Duration.zero);
    });

    _player.bufferedPositionStream.listen((bufferedPosition) {
      _bufferedPositionSubject.add(bufferedPosition);
    });

    _player.currentIndexStream.listen((index) {
      // Handle track changes
    });
  }

  // ============ Load Track ============

  Future<void> loadTrack(Track track) async {
    try {
      await stop();
      await _player.setAudioSource(
        AudioSource.uri(Uri.file(track.filePath)),
      );
      _currentTrackSubject.add(track);
    } catch (e) {
      print('Error loading track: $e');
    }
  }

  Future<void> loadPlaylist(List<Track> tracks, {int startIndex = 0}) async {
    try {
      await stop();
      
      final audioSources = tracks
          .map((track) => AudioSource.uri(Uri.file(track.filePath)))
          .toList();

      await _player.setAudioSource(
        ConcatenatingAudioSource(children: audioSources),
        initialIndex: startIndex,
        initialPosition: Duration.zero,
      );

      if (tracks.isNotEmpty) {
        _currentTrackSubject.add(tracks[startIndex]);
      }
    } catch (e) {
      print('Error loading playlist: $e');
    }
  }

  // ============ Playback Controls ============

  Future<void> play() async {
    try {
      await _player.play();
    } catch (e) {
      print('Error playing: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (e) {
      print('Error pausing: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
      _currentTrackSubject.add(null);
    } catch (e) {
      print('Error stopping: $e');
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } catch (e) {
      print('Error seeking: $e');
    }
  }

  Future<void> skipToNext() async {
    try {
      await _player.seekToNext();
    } catch (e) {
      print('Error skipping to next: $e');
    }
  }

  Future<void> skipToPrevious() async {
    try {
      await _player.seekToPrevious();
    } catch (e) {
      print('Error skipping to previous: $e');
    }
  }

  // ============ Queue Management ============

  Future<void> addToQueue(Track track) async {
    try {
      await _player.addAudioSource(
        AudioSource.uri(Uri.file(track.filePath)),
      );
    } catch (e) {
      print('Error adding to queue: $e');
    }
  }

  Future<void> removeFromQueue(int index) async {
    try {
      await _player.removeAudioSourceAt(index);
    } catch (e) {
      print('Error removing from queue: $e');
    }
  }

  Future<void> clearQueue() async {
    try {
      await _player.stop();
    } catch (e) {
      print('Error clearing queue: $e');
    }
  }

  // ============ Settings ============

  Future<void> setVolume(double volume) async {
    try {
      await _player.setVolume(volume.clamp(0.0, 1.0));
      _volumeSubject.add(volume);
    } catch (e) {
      print('Error setting volume: $e');
    }
  }

  Future<void> setSpeed(double speed) async {
    try {
      await _player.setSpeed(speed);
      _speedSubject.add(speed);
    } catch (e) {
      print('Error setting speed: $e');
    }
  }

  Future<void> setLoopMode(LoopMode mode) async {
    try {
      await _player.setLoopMode(mode);
      _repeatModeSubject.add(mode);
    } catch (e) {
      print('Error setting loop mode: $e');
    }
  }

  Future<void> setShuffleMode(bool enabled) async {
    try {
      await _player.setShuffleModeEnabled(enabled);
      _shuffleModeSubject.add(enabled);
    } catch (e) {
      print('Error setting shuffle mode: $e');
    }
  }

  // ============ Getters ============

  ValueStream<Track?> get currentTrackStream => _currentTrackSubject.stream;
  ValueStream<PlayerState> get playerStateStream => _playerStateSubject.stream;
  ValueStream<Duration> get positionStream => _positionSubject.stream;
  ValueStream<Duration> get durationStream => _durationSubject.stream;
  ValueStream<Duration> get bufferedPositionStream => _bufferedPositionSubject.stream;
  ValueStream<double> get volumeStream => _volumeSubject.stream;
  ValueStream<double> get speedStream => _speedSubject.stream;
  ValueStream<LoopMode> get repeatModeStream => _repeatModeSubject.stream;
  ValueStream<bool> get shuffleModeStream => _shuffleModeSubject.stream;

  Track? get currentTrack => _currentTrackSubject.value;
  PlayerState get playerState => _playerStateSubject.value;
  Duration get position => _positionSubject.value;
  Duration get duration => _durationSubject.value;
  Duration get bufferedPosition => _bufferedPositionSubject.value;
  double get volume => _volumeSubject.value;
  double get speed => _speedSubject.value;
  LoopMode get repeatMode => _repeatModeSubject.value;
  bool get shuffleMode => _shuffleModeSubject.value;

  // ============ Cleanup ============

  Future<void> dispose() async {
    try {
      await _player.stop();
      await _player.dispose();
      await _currentTrackSubject.close();
      await _playerStateSubject.close();
      await _positionSubject.close();
      await _durationSubject.close();
      await _bufferedPositionSubject.close();
      await _volumeSubject.close();
      await _speedSubject.close();
      await _repeatModeSubject.close();
      await _shuffleModeSubject.close();
    } catch (e) {
      print('Error disposing player: $e');
    }
  }
}
