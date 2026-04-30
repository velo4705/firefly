import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firefly/domain/entities/track.dart';

class DirectoryScanner {
  static final DirectoryScanner _instance = DirectoryScanner._internal();
  factory DirectoryScanner() => _instance;
  DirectoryScanner._internal();

  /// Request storage permission for mobile platforms
  Future<bool> requestPermission() async {
    if (Platform.isAndroid || Platform.isIOS) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      return status.isGranted;
    }
    return true; // Desktop platforms don't need permission
  }

  /// Scan directory for music files recursively
  Future<List<Track>> scanDirectory(String directoryPath) async {
    final tracks = <Track>[];
    final dir = Directory(directoryPath);

    if (!await dir.exists()) {
      throw Exception('Directory does not exist: $directoryPath');
    }

    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File && _isMusicFile(entity.path)) {
        try {
          final track = await _createTrackFromFile(entity);
          if (track != null) {
            tracks.add(track);
          }
        } catch (e) {
          // Skip files that can't be processed
          print('Error processing file ${entity.path}: $e');
        }
      }
    }

    return tracks;
  }

  /// Check if file is a music file based on extension
  bool _isMusicFile(String filePath) {
    final extension = p.extension(filePath).toLowerCase();
    const musicExtensions = {
      '.mp3',
      '.flac',
      '.wav',
      '.ogg',
      '.m4a',
      '.aac',
      '.wma',
      '.opus',
      '.aiff',
      '.alac',
    };
    return musicExtensions.contains(extension);
  }

  /// Create Track entity from File
  Future<Track?> _createTrackFromFile(File file) async {
    try {
      final stat = await file.stat();
      final fileName = p.basenameWithoutExtension(file.path);
      final title = _extractTitle(fileName);
      final artist = _extractArtist(fileName);
      final album = _extractAlbum(file.parent.path);

      return Track(
        id: file.path.hashCode.toString(),
        title: title,
        artist: artist,
        album: album,
        filePath: file.path,
        duration: Duration.zero, // Will be populated by metadata extractor
        fileSize: stat.size,
        createdAt: stat.changed,
        genre: 'Unknown',
        bitrate: 0,
        sampleRate: 0,
        channels: 0,
      );
    } catch (e) {
      print('Error creating track from file ${file.path}: $e');
      return null;
    }
  }

  String _extractTitle(String fileName) {
    // Remove common patterns and clean up
    var title = fileName;
    final patterns = [
      r'\[.*?\]', // Remove [brackets]
      r'\(.*?\)', // Remove (parentheses)
      r'\{.*?\}', // Remove {braces}
      r'-\s*[^-]+$', // Remove trailing artist after last hyphen
    ];
    for (var pattern in patterns) {
      title = title.replaceAll(RegExp(pattern), '');
    }
    return title.trim().split(' - ').last.trim();
  }

  String _extractArtist(String fileName) {
    // Try to extract artist from common patterns
    final artistMatch = RegExp(r'^(.*?)\s*-\s*').firstMatch(fileName);
    if (artistMatch != null) {
      return artistMatch.group(1)?.trim() ?? 'Unknown Artist';
    }
    return 'Unknown Artist';
  }

  String _extractAlbum(String directoryPath) {
    final dir = Directory(directoryPath);
    return p.basename(dir.path);
  }

  /// Get default music directories for the platform
  Future<List<String>> getDefaultMusicDirectories() async {
    final directories = <String>[];

    if (Platform.isAndroid || Platform.isIOS) {
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        directories.add(externalDir.path);
      }
    } else if (Platform.isWindows || Platform.isLinux) {
      final homeDir = Platform.environment['HOME'] ?? 
                     Platform.environment['USERPROFILE'] ?? 
                     '';
      if (homeDir.isNotEmpty) {
        final musicDir = p.join(homeDir, 'Music');
        if (await Directory(musicDir).exists()) {
          directories.add(musicDir);
        }
      }
    } else if (Platform.isMacOS) {
      final homeDir = Platform.environment['HOME'] ?? '';
      if (homeDir.isNotEmpty) {
        final musicDir = p.join(homeDir, 'Music');
        if (await Directory(musicDir).exists()) {
          directories.add(musicDir);
        }
      }
    }

    return directories;
  }
}
