import 'package:firefly/domain/entities/track.dart';

abstract class LocalRepository {
  /// Scan local directory for music files
  Future<List<Track>> scanDirectory(String directoryPath);

  /// Get all tracks from database
  Future<List<Track>> getLocalTracks();

  /// Get favorite tracks
  Future<List<Track>> getFavoriteTracks();

  /// Search tracks by query
  Future<List<Track>> searchTracks(String query);

  /// Get tracks by artist
  Future<List<Track>> getTracksByArtist(String artist);

  /// Get tracks by album
  Future<List<Track>> getTracksByAlbum(String album);

  /// Get recently played tracks
  Future<List<Track>> getRecentTracks();

  /// Increment play count for a track
  Future<void> incrementPlayCount(String trackId);

  /// Toggle favorite status for a track
  Future<void> toggleFavorite(String trackId);

  /// Set the music directory path
  Future<void> setMusicDirectory(String path);

  /// Get the last used music directory
  Future<String?> getLastMusicDirectory();

  /// Delete a track from the database
  Future<void> deleteTrack(String trackId);

  /// Clear all tracks from the database
  Future<void> clearAllTracks();
}
