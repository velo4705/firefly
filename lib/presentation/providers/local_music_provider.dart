import 'package:flutter/material.dart';
import 'package:firefly/domain/entities/track.dart';

class LocalMusicProvider extends ChangeNotifier {
  List<Track> _tracks = [];
  bool _isLoading = false;
  bool _isScanning = false;
  String? _errorMessage;
  Track? _selectedTrack;
  bool _isPlaying = false;

  List<Track> get tracks => _tracks;
  bool get isLoading => _isLoading;
  bool get isScanning => _isScanning;
  String? get errorMessage => _errorMessage;
  Track? get selectedTrack => _selectedTrack;
  bool get isPlaying => _isPlaying;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setScanning(bool scanning) {
    _isScanning = scanning;
    notifyListeners();
  }

  void setTracks(List<Track> tracks) {
    _tracks = tracks;
    _errorMessage = null;
    notifyListeners();
  }

  void setError(String error) {
    _errorMessage = error;
    _isLoading = false;
    _isScanning = false;
    notifyListeners();
  }

  void selectTrack(Track track) {
    _selectedTrack = track;
    notifyListeners();
  }

  void playTrack(Track track) {
    _selectedTrack = track;
    _isPlaying = true;
    notifyListeners();
  }

  void pauseTrack() {
    _isPlaying = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}