import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/track_model.dart';

class MusicDatabase {
  static final MusicDatabase _instance = MusicDatabase._internal();
  factory MusicDatabase() => _instance;
  MusicDatabase._internal();

  static const String _boxName = 'music_library';
  static const String _playlistBoxName = 'playlists';
  static const String _prefsBoxName = 'app_preferences';

  Box<TrackModel>? _trackBox;
  Box? _playlistBox;
  Box? _prefsBox;

  /// Initialize Hive and open boxes
  Future<void> initialize() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TrackModelAdapter());
    }

    _trackBox = await Hive.openBox<TrackModel>(_boxName);
    _playlistBox = await Hive.openBox(_playlistBoxName);
    _prefsBox = await Hive.openBox(_prefsBoxName);
  }

  /// Get the main track box
  Box<TrackModel> get trackBox {
    if (_trackBox == null) {
      throw Exception('MusicDatabase not initialized. Call initialize() first.');
    }
    return _trackBox!;
  }

  /// Get the playlist box
  Box get playlistBox {
    if (_playlistBox == null) {
      throw Exception('MusicDatabase not initialized. Call initialize() first.');
    }
    return _playlistBox!;
  }

  /// Get the preferences box
  Box get prefsBox {
    if (_prefsBox == null) {
      throw Exception('MusicDatabase not initialized. Call initialize() first.');
    }
    return _prefsBox!;
  }

  // ============ Track Operations ============

  /// Add a track to the database
  Future<void> addTrack(TrackModel track) async {
    await trackBox.put(track.id, track);
  }

  /// Add multiple tracks to the database
  Future<void> addTracks(List<TrackModel> tracks) async {
    await trackBox.putAll(Map.fromEntries(
      tracks.map((track) => MapEntry(track.id, track)),
    ));
  }

  /// Get a track by ID
  TrackModel? getTrack(String id) {
    return trackBox.get(id);
  }

  /// Get all tracks from the database
  List<TrackModel> getAllTracks() {
    return trackBox.values.toList();
  }

  /// Get tracks sorted by title
  List<TrackModel> getTracksSortedByTitle() {
    final tracks = trackBox.values.toList();
    tracks.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    return tracks;
  }

  /// Get tracks sorted by artist
  List<TrackModel> getTracksSortedByArtist() {
    final tracks = trackBox.values.toList();
    tracks.sort((a, b) => a.artist.toLowerCase().compareTo(b.artist.toLowerCase()));
    return tracks;
  }

  /// Get tracks sorted by album
  List<TrackModel> getTracksSortedByAlbum() {
    final tracks = trackBox.values.toList();
    tracks.sort((a, b) => a.album.toLowerCase().compareTo(b.album.toLowerCase()));
    return tracks;
  }

  /// Get favorite tracks
  List<TrackModel> getFavoriteTracks() {
    return trackBox.values.where((track) => track.isFavorite).toList();
  }

  /// Search tracks by query
  List<TrackModel> searchTracks(String query) {
    final lowercaseQuery = query.toLowerCase();
    return trackBox.values.where((track) {
      return track.title.toLowerCase().contains(lowercaseQuery) ||
             track.artist.toLowerCase().contains(lowercaseQuery) ||
             track.album.toLowerCase().contains(lowercaseQuery) ||
             track.genre.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  /// Update a track
  Future<void> updateTrack(TrackModel track) async {
    await trackBox.put(track.id, track);
  }

  /// Delete a track
  Future<void> deleteTrack(String id) async {
    await trackBox.delete(id);
  }

  /// Delete all tracks
  Future<void> clearAllTracks() async {
    await trackBox.clear();
  }

  /// Get tracks by artist
  List<TrackModel> getTracksByArtist(String artist) {
    return trackBox.values
        .where((track) => track.artist.toLowerCase() == artist.toLowerCase())
        .toList();
  }

  /// Get tracks by album
  List<TrackModel> getTracksByAlbum(String album) {
    return trackBox.values
        .where((track) => track.album.toLowerCase() == album.toLowerCase())
        .toList();
  }

  /// Increment play count for a track
  Future<void> incrementPlayCount(String id) async {
    final track = trackBox.get(id);
    if (track != null) {
      final updatedTrack = track.copyWith(
        playCount: track.playCount + 1,
        lastPlayed: DateTime.now(),
      );
      await trackBox.put(id, updatedTrack);
    }
  }

  /// Toggle favorite status for a track
  Future<void> toggleFavorite(String id) async {
    final track = trackBox.get(id);
    if (track != null) {
      final updatedTrack = track.copyWith(
        isFavorite: !track.isFavorite,
      );
      await trackBox.put(id, updatedTrack);
    }
  }

  // ============ Playlist Operations ============

  /// Create a playlist
  Future<void> createPlaylist(String name, List<String> trackIds) async {
    final playlistKey = 'playlist_${DateTime.now().millisecondsSinceEpoch}';
    final playlist = {
      'id': playlistKey,
      'name': name,
      'trackIds': trackIds,
      'createdAt': DateTime.now().toIso8601String(),
    };
    await playlistBox.put(playlistKey, playlist);
  }

  /// Get all playlists
  List<Map<String, dynamic>> getAllPlaylists() {
    return playlistBox.values.cast<Map<String, dynamic>>().toList();
  }

  /// Get a playlist by ID
  Map<String, dynamic>? getPlaylist(String id) {
    final playlist = playlistBox.get(id);
    return playlist != null ? Map<String, dynamic>.from(playlist) : null;
  }

  /// Update a playlist
  Future<void> updatePlaylist(String id, String name, List<String> trackIds) async {
    final playlist = {
      'id': id,
      'name': name,
      'trackIds': trackIds,
      'updatedAt': DateTime.now().toIso8601String(),
    };
    await playlistBox.put(id, playlist);
  }

  /// Delete a playlist
  Future<void> deletePlaylist(String id) async {
    await playlistBox.delete(id);
  }

  // ============ Preference Operations ============

  /// Save a preference
  Future<void> savePreference(String key, dynamic value) async {
    await prefsBox.put(key, value);
  }

  /// Get a preference
  dynamic getPreference(String key) {
    return prefsBox.get(key);
  }

  /// Get last music directory
  String? getLastMusicDirectory() {
    return prefsBox.get('last_music_directory');
  }

  /// Set last music directory
  Future<void> setLastMusicDirectory(String path) async {
    await prefsBox.put('last_music_directory', path);
  }

  /// Close all boxes
  Future<void> close() async {
    await _trackBox?.close();
    await _playlistBox?.close();
    await _prefsBox?.close();
    Hive.close();
  }
}
