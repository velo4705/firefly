import 'package:flutter/material.dart';
import 'package:firefly/domain/entities/track.dart';

class AudioPlayerProvider extends ChangeNotifier {
  Track? _currentTrack;
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _volume = 0.8;
  bool _isMuted = false;
  PlaybackMode _playbackMode = PlaybackMode.repeat;

  Track? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  Duration get position => _position;
  Duration get duration => _duration;
  double get volume => _volume;
  bool get isMuted => _isMuted;
  PlaybackMode get playbackMode => _playbackMode;
  double get progress => _duration.inMilliseconds > 0 
      ? _position.inMilliseconds / _duration.inMilliseconds 
      : 0.0;

  void loadTrack(Track track) {
    _currentTrack = track;
    _isLoading = true;
    _position = Duration.zero;
    notifyListeners();

    // Simulate loading
    Future.delayed(const Duration(milliseconds: 500), () {
      _duration = track.duration;
      _isLoading = false;
      notifyListeners();
    });
  }

  void play() {
    if (_currentTrack == null) return;
    
    _isPlaying = true;
    _startPositionUpdates();
    notifyListeners();
  }

  void pause() {
    _isPlaying = false;
    notifyListeners();
  }

  void togglePlayPause() {
    if (_isPlaying) {
      pause();
    } else {
      play();
    }
  }

  void seekTo(Duration position) {
    _position = position;
    notifyListeners();
  }

  void seekToPercentage(double percentage) {
    if (_duration.inMilliseconds > 0) {
      final newPosition = Duration(
        milliseconds: (_duration.inMilliseconds * percentage).round(),
      );
      seekTo(newPosition);
    }
  }

  void skipToNext() {
    // This would be implemented with playlist logic
    if (_currentTrack != null) {
      // For demo, just restart the current track
      seekTo(Duration.zero);
    }
  }

  void skipToPrevious() {
    // This would be implemented with playlist logic
    if (_currentTrack != null) {
      // For demo, just restart the current track
      seekTo(Duration.zero);
    }
  }

  void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
    _isMuted = volume == 0.0;
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    notifyListeners();
  }

  void togglePlaybackMode() {
    switch (_playbackMode) {
      case PlaybackMode.repeat:
        _playbackMode = PlaybackMode.repeatOne;
        break;
      case PlaybackMode.repeatOne:
        _playbackMode = PlaybackMode.shuffle;
        break;
      case PlaybackMode.shuffle:
        _playbackMode = PlaybackMode.repeat;
        break;
    }
    notifyListeners();
  }

  void stop() {
    _isPlaying = false;
    _position = Duration.zero;
    _currentTrack = null;
    notifyListeners();
  }

  void _startPositionUpdates() {
    if (!_isPlaying) return;

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_isPlaying && _currentTrack != null) {
        final newPosition = _position + const Duration(milliseconds: 100);
        if (newPosition < _duration) {
          _position = newPosition;
          notifyListeners();
          _startPositionUpdates();
        } else {
          // Track ended
          if (_playbackMode == PlaybackMode.repeatOne) {
            seekTo(Duration.zero);
            _startPositionUpdates();
          } else {
            skipToNext();
          }
        }
      }
    });
  }
}

enum PlaybackMode {
  repeat,
  repeatOne,
  shuffle,
}

enum PlayerState {
  playing,
  paused,
  idle,
}