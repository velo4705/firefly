import 'package:firefly/domain/usecases/local/scan_local_music_usecase.dart';
import 'package:firefly/domain/repositories/local_repository.dart';
import 'package:firefly/domain/entities/track.dart';
import 'package:firefly/data/datasources/file/directory_scanner.dart';
import 'package:firefly/data/datasources/file/metadata_extractor.dart';
import 'package:firefly/data/models/track_model.dart';
import 'package:firefly/data/datasources/local/music_database.dart';

class LocalRepositoryImpl implements LocalRepository {
  final DirectoryScanner _scanner = DirectoryScanner();
  final MetadataExtractor _metadataExtractor = MetadataExtractor();
  final MusicDatabase _database = MusicDatabase();

  @override
  Future<List<Track>> scanDirectory(String directoryPath) async {
    try {
      // 1. Scan directory for music files
      final tracks = await _scanner.scanDirectory(directoryPath);
      
      // 2. Extract metadata for each track
      final processedTracks = <Track>[];
      for (final track in tracks) {
        final trackWithMetadata = await _metadataExtractor.extractMetadata(track);
        processedTracks.add(trackWithMetadata);
      }

      // 3. Save to database
      final trackModels = processedTracks
          .map((track) => TrackModel.fromTrack(track))
          .toList();
      await _database.addTracks(trackModels);

      return processedTracks;
    } catch (e) {
      throw Exception('Failed to scan directory: $e');
    }
  }

  @override
  Future<List<Track>> getLocalTracks() async {
    try {
      final allTracks = _database.getAllTracks();
      return allTracks.take(20).map((model) => model.toTrack()).toList().cast<Track>();
    } catch (e) {
      throw Exception('Failed to get recent tracks: $e');
    }
  }

  @override
  Future<List<Track>> getFavoriteTracks() async {
    try {
      final trackModels = _database.getFavoriteTracks();
      return trackModels.map((model) => model.toTrack()).toList().cast<Track>();
    } catch (e) {
      throw Exception('Failed to get favorite tracks: $e');
    }
  }

  @override
  Future<List<Track>> searchTracks(String query) async {
    try {
      final trackModels = _database.searchTracks(query);
      return trackModels.map((model) => model.toTrack()).toList().cast<Track>();
    } catch (e) {
      throw Exception('Failed to search tracks: $e');
    }
  }

  @override
  Future<List<Track>> getTracksByArtist(String artist) async {
    try {
      final trackModels = _database.getTracksByArtist(artist);
      return trackModels.map((model) => model.toTrack()).toList().cast<Track>();
    } catch (e) {
      throw Exception('Failed to get tracks by artist: $e');
    }
  }

  @override
  Future<List<Track>> getTracksByAlbum(String album) async {
    try {
      final trackModels = _database.getTracksByAlbum(album);
      return trackModels.map((model) => model.toTrack()).toList().cast<Track>();
    } catch (e) {
      throw Exception('Failed to get tracks by album: $e');
    }
  }

  @override
  Future<List<Track>> getRecentTracks() async {
    try {
      final allTracks = _database.getAllTracks();
      allTracks.sort((a, b) {
        final aLastPlayed = a.lastPlayed;
        final bLastPlayed = b.lastPlayed;
        if (aLastPlayed == null && bLastPlayed == null) return 0;
        if (aLastPlayed == null) return 1;
        if (bLastPlayed == null) return -1;
        return bLastPlayed.compareTo(aLastPlayed);
      });
      return allTracks.take(20).map((model) => model.toTrack()).toList().cast<Track>();
    } catch (e) {
      throw Exception('Failed to get recent tracks: $e');
    }
  }

  @override
  Future<void> incrementPlayCount(String trackId) async {
    try {
      await _database.incrementPlayCount(trackId);
    } catch (e) {
      throw Exception('Failed to increment play count: $e');
    }
  }

  @override
  Future<void> toggleFavorite(String trackId) async {
    try {
      await _database.toggleFavorite(trackId);
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }

  @override
  Future<void> setMusicDirectory(String path) async {
    try {
      await _database.setLastMusicDirectory(path);
    } catch (e) {
      throw Exception('Failed to set music directory: $e');
    }
  }

  @override
  Future<String?> getLastMusicDirectory() async {
    try {
      return _database.getLastMusicDirectory();
    } catch (e) {
      throw Exception('Failed to get last music directory: $e');
    }
  }

  @override
  Future<void> deleteTrack(String trackId) async {
    try {
      await _database.deleteTrack(trackId);
    } catch (e) {
      throw Exception('Failed to delete track: $e');
    }
  }

  @override
  Future<void> clearAllTracks() async {
    try {
      await _database.clearAllTracks();
    } catch (e) {
      throw Exception('Failed to clear all tracks: $e');
    }
  }
}
