import 'package:firefly/domain/entities/playlist.dart';
import 'package:firefly/domain/entities/track.dart';
import 'package:firefly/data/datasources/local/music_database.dart';

abstract class PlaylistRepository {
  /// Create a new playlist
  Future<void> createPlaylist(String name, List<Track> tracks);

  /// Update an existing playlist
  Future<void> updatePlaylist(String id, String name, List<Track> tracks);

  /// Delete a playlist
  Future<void> deletePlaylist(String id);

  /// Get all playlists
  Future<List<Playlist>> getAllPlaylists();

  /// Get a specific playlist by ID
  Future<Playlist?> getPlaylist(String id);

  /// Add tracks to a playlist
  Future<void> addTracksToPlaylist(String playlistId, List<Track> tracks);

  /// Remove tracks from a playlist
  Future<void> removeTracksFromPlaylist(String playlistId, List<String> trackIds);

  /// Get tracks in a playlist
  Future<List<Track>> getPlaylistTracks(String playlistId);

  /// Get playlists containing a specific track
  Future<List<Playlist>> getPlaylistsForTrack(String trackId);
}

class PlaylistRepositoryImpl implements PlaylistRepository {
  final MusicDatabase _database;

  PlaylistRepositoryImpl(this._database);

  @override
  Future<void> createPlaylist(String name, List<Track> tracks) async {
    final trackIds = tracks.map((track) => track.id).toList();
    await _database.createPlaylist(name, trackIds);
  }

  @override
  Future<void> updatePlaylist(String id, String name, List<Track> tracks) async {
    final trackIds = tracks.map((track) => track.id).toList();
    await _database.updatePlaylist(id, name, trackIds);
  }

  @override
  Future<void> deletePlaylist(String id) async {
    await _database.deletePlaylist(id);
  }

  @override
  Future<List<Playlist>> getAllPlaylists() async {
    final playlists = _database.getAllPlaylists();
    return playlists.map((data) {
      return Playlist(
        id: data['id'] ?? '',
        name: data['name'] ?? 'Untitled',
        trackIds: List<String>.from(data['trackIds'] ?? []),
        createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
        updatedAt: data['updatedAt'] != null
            ? DateTime.tryParse(data['updatedAt'])
            : null,
      );
    }).toList();
  }

  @override
  Future<Playlist?> getPlaylist(String id) async {
    final data = _database.getPlaylist(id);
    if (data == null) return null;

    return Playlist(
      id: data['id'] ?? '',
      name: data['name'] ?? 'Untitled',
      trackIds: List<String>.from(data['trackIds'] ?? []),
      createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.tryParse(data['updatedAt'])
          : null,
    );
  }

  @override
  Future<void> addTracksToPlaylist(String playlistId, List<Track> tracks) async {
    final playlist = await getPlaylist(playlistId);
    if (playlist == null) return;

    final newTrackIds = tracks.map((track) => track.id).toList();
    final updatedTrackIds = [...playlist.trackIds, ...newTrackIds].toSet().toList();
    
    await _database.updatePlaylist(playlistId, playlist.name, []);
  }

  @override
  Future<void> removeTracksFromPlaylist(String playlistId, List<String> trackIds) async {
    final playlist = await getPlaylist(playlistId);
    if (playlist == null) return;

    final updatedTrackIds = playlist.trackIds
        .where((id) => !trackIds.contains(id))
        .toList();

    await _database.updatePlaylist(playlistId, playlist.name, []);
  }

  @override
  Future<List<Track>> getPlaylistTracks(String playlistId) async {
    final playlist = await getPlaylist(playlistId);
    if (playlist == null) return [];

    final allTracks = _database.getAllTracks();
    return allTracks
        .where((track) => playlist.trackIds.contains(track.id))
        .map((model) => model.toTrack())
        .toList();
  }

  @override
  Future<List<Playlist>> getPlaylistsForTrack(String trackId) async {
    final allPlaylists = await getAllPlaylists();
    return allPlaylists
        .where((playlist) => playlist.trackIds.contains(trackId))
        .toList();
  }
}
