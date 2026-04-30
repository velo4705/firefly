import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:firefly/domain/entities/track.dart';
import 'package:just_audio/just_audio.dart';

/// Extracts metadata from audio files
class MetadataExtractor {
  static final MetadataExtractor _instance = MetadataExtractor._internal();
  factory MetadataExtractor() => _instance;
  MetadataExtractor._internal();

  /// Extract metadata from audio file
  Future<Track> extractMetadata(Track track, {bool skipDuration = false}) async {
    try {
      // Use just_audio to get duration and other basic info
      final player = AudioPlayer();
      
      try {
        if (!skipDuration) {
          await player.setFilePath(track.filePath);
          final duration = player.duration ?? Duration.zero;
          track = track.copyWith(duration: duration);
        }
      } catch (e) {
        print('Error getting duration for ${track.filePath}: $e');
      } finally {
        await player.dispose();
      }

      // Extract from filename if metadata not available
      if (track.duration == Duration.zero) {
        // Could use external libraries like `audio_metadata` for better extraction
        print('Duration extraction failed for ${track.filePath}');
      }

      // Try to read file metadata using platform-specific methods
      final file = File(track.filePath);
      final bytes = await file.readAsBytes();
      final metadata = _parseMetadata(bytes, track.filePath);

      return track.copyWith(
        title: metadata['title'] ?? track.title,
        artist: metadata['artist'] ?? track.artist,
        album: metadata['album'] ?? track.album,
        genre: metadata['genre'] ?? track.genre,
        bitrate: metadata['bitrate'] ?? track.bitrate,
        sampleRate: metadata['sampleRate'] ?? track.sampleRate,
        channels: metadata['channels'] ?? track.channels,
      );
    } catch (e) {
      print('Error extracting metadata for ${track.filePath}: $e');
      return track;
    }
  }

  /// Parse audio metadata from file bytes
  Map<String, dynamic> _parseMetadata(List<int> bytes, String filePath) {
    final extension = p.extension(filePath).toLowerCase();
    final metadata = <String, dynamic>{};

    try {
      switch (extension) {
        case '.mp3':
          _parseId3v2Tags(bytes, metadata);
          break;
        case '.flac':
          _parseFlacTags(bytes, metadata);
          break;
        case '.m4a':
          _parseMp4Tags(bytes, metadata);
          break;
        case '.ogg':
          _parseVorbisTags(bytes, metadata);
          break;
        case '.wav':
          _parseRiffTags(bytes, metadata);
          break;
      }
    } catch (e) {
      print('Error parsing metadata: $e');
    }

    return metadata;
  }

  /// Parse ID3v2 tags (MP3)
  void _parseId3v2Tags(List<int> bytes, Map<String, dynamic> metadata) {
    try {
      if (bytes.length < 10) return;

      // Check for ID3 header
      if (bytes[0] == 0x49 && bytes[1] == 0x44 && bytes[2] == 0x33) {
        // ID3v2 header found
        final version = bytes[3];
        final flags = bytes[5];
        final size = ((bytes[6] & 0x7F) << 21) |
                    ((bytes[7] & 0x7F) << 14) |
                    ((bytes[8] & 0x7F) << 7) |
                    (bytes[9] & 0x7F);

        var pos = 10;
        if ((flags & 0x10) != 0) {
          pos += 10; // Skip extended header
        }

        while (pos < bytes.length - 10 && pos < size) {
          final frameId = String.fromCharCodes(bytes.sublist(pos, pos + 4));
          final frameSize = ((bytes[pos + 4] & 0x7F) << 24) |
                           ((bytes[pos + 5] & 0x7F) << 16) |
                           ((bytes[pos + 6] & 0x7F) << 8) |
                           (bytes[pos + 7] & 0x7F);
          final flags = ((bytes[pos + 8] << 8) | bytes[pos + 9]);

          pos += 10;

          if (frameSize == 0 || pos + frameSize > bytes.length) break;

          final frameData = bytes.sublist(pos, pos + frameSize);

          switch (frameId) {
            case 'TIT2': // Title
              metadata['title'] = _decodeId3Text(frameData);
              break;
            case 'TPE1': // Artist
              metadata['artist'] = _decodeId3Text(frameData);
              break;
            case 'TALB': // Album
              metadata['album'] = _decodeId3Text(frameData);
              break;
            case 'TCON': // Genre
              metadata['genre'] = _decodeId3Text(frameData);
              break;
          }

          pos += frameSize;
        }
      }
    } catch (e) {
      print('Error parsing ID3 tags: $e');
    }
  }

  String _decodeId3Text(List<int> data) {
    if (data.isEmpty) return '';
    
    final encoding = data[0];
    final textBytes = data.sublist(1);

    try {
      switch (encoding) {
        case 0: // ISO-8859-1
          return String.fromCharCodes(textBytes);
        case 1: // UTF-16 with BOM
        case 2: // UTF-16 BE without BOM
          return String.fromCharCodes(textBytes);
        case 3: // UTF-8
          return String.fromCharCodes(textBytes);
        default:
          return String.fromCharCodes(textBytes);
      }
    } catch (e) {
      return String.fromCharCodes(textBytes);
    }
  }

  /// Parse FLAC metadata
  void _parseFlacTags(List<int> bytes, Map<String, dynamic> metadata) {
    try {
      if (bytes.length < 4) return;
      
      // Check for FLAC signature "fLaC"
      if (bytes[0] != 0x66 || bytes[1] != 0x4C || bytes[2] != 0x61 || bytes[3] != 0x43) {
        return;
      }

      var pos = 4;
      while (pos < bytes.length - 4) {
        final isLast = (bytes[pos] & 0x80) != 0;
        final blockType = bytes[pos] & 0x7F;
        final length = ((bytes[pos + 1] << 16) | (bytes[pos + 2] << 8) | bytes[pos + 3]);
        pos += 4;

        if (blockType == 4) { // VORBIS_COMMENT
          _parseVorbisComment(bytes.sublist(pos, pos + length), metadata);
        }

        pos += length;
        if (isLast) break;
      }
    } catch (e) {
      print('Error parsing FLAC metadata: $e');
    }
  }

  /// Parse Vorbis comments
  void _parseVorbisComment(List<int> data, Map<String, dynamic> metadata) {
    try {
      if (data.length < 4) return;
      
      var pos = 4;
      final vendorLength = (data[0] | (data[1] << 8) | (data[2] << 16) | (data[3] << 24));
      pos += 4 + vendorLength;
      
      final commentCount = (data[pos] | (data[pos + 1] << 8) | (data[pos + 2] << 16) | (data[pos + 3] << 24));
      pos += 4;

      for (var i = 0; i < commentCount && pos < data.length; i++) {
        final commentLength = (data[pos] | (data[pos + 1] << 8) | (data[pos + 2] << 16) | (data[pos + 3] << 24));
        pos += 4;

        if (pos + commentLength > data.length) break;

        final comment = String.fromCharCodes(data.sublist(pos, pos + commentLength));
        final parts = comment.split('=');
        if (parts.length == 2) {
          final key = parts[0].toUpperCase();
          final value = parts[1];

          switch (key) {
            case 'TITLE':
              metadata['title'] = value;
              break;
            case 'ARTIST':
              metadata['artist'] = value;
              break;
            case 'ALBUM':
              metadata['album'] = value;
              break;
            case 'GENRE':
              metadata['genre'] = value;
              break;
          }
        }
        pos += commentLength;
      }
    } catch (e) {
      print('Error parsing Vorbis comments: $e');
    }
  }

  /// Parse MP4 (M4A) tags
  void _parseMp4Tags(List<int> bytes, Map<String, dynamic> metadata) {
    try {
      if (bytes.length < 8) return;

      var pos = 0;
      while (pos < bytes.length - 8) {
        final size = (bytes[pos] << 24) | (bytes[pos + 1] << 16) | (bytes[pos + 2] << 8) | bytes[pos + 3];
        final type = String.fromCharCodes(bytes.sublist(pos + 4, pos + 8));

        if (size == 0) break;

        if (type == 'moov') {
          _parseMp4Moov(bytes.sublist(pos + 8, pos + size), metadata);
          break;
        }

        pos += size;
      }
    } catch (e) {
      print('Error parsing MP4 tags: $e');
    }
  }

  void _parseMp4Moov(List<int> data, Map<String, dynamic> metadata) {
    // Simplified parsing - in production would use proper atom parsing
    try {
      var pos = 0;
      while (pos < data.length - 8) {
        final size = (data[pos] << 24) | (data[pos + 1] << 16) | (data[pos + 2] << 8) | data[pos + 3];
        final type = String.fromCharCodes(data.sublist(pos + 4, pos + 8));

        if (size == 0) break;

        if (type == 'udta') {
          // User data - contains metadata
          break;
        }

        pos += size;
      }
    } catch (e) {
      print('Error parsing moov atom: $e');
    }
  }

  /// Parse RIFF/WAV tags
  void _parseRiffTags(List<int> bytes, Map<String, dynamic> metadata) {
    try {
      if (bytes.length < 12) return;

      // Check for RIFF header
      if (!(bytes[0] == 0x52 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes[3] == 0x46 &&
            bytes[8] == 0x57 && bytes[9] == 0x41 && bytes[10] == 0x56 && bytes[11] == 0x45)) {
        return;
      }

      var pos = 12;
      while (pos < bytes.length - 8) {
        final chunkId = String.fromCharCodes(bytes.sublist(pos, pos + 4));
        final chunkSize = (bytes[pos + 4] | (bytes[pos + 5] << 8) | (bytes[pos + 6] << 16) | (bytes[pos + 7] << 24));

        if (chunkId == 'LIST' && pos + 8 + chunkSize <= bytes.length) {
          final listType = String.fromCharCodes(bytes.sublist(pos + 8, pos + 12));
          if (listType == 'INFO') {
            _parseRiffInfoChunk(bytes.sublist(pos + 12, pos + 8 + chunkSize), metadata);
          }
        }

        pos += 8 + chunkSize;
        if (chunkSize % 2 != 0) pos++; // Pad to word boundary
      }
    } catch (e) {
      print('Error parsing RIFF tags: $e');
    }
  }

  void _parseRiffInfoChunk(List<int> data, Map<String, dynamic> metadata) {
    var pos = 0;
    while (pos < data.length - 8) {
      final chunkId = String.fromCharCodes(data.sublist(pos, pos + 4));
      final chunkSize = (data[pos + 4] | (data[pos + 5] << 8) | (data[pos + 6] << 16) | (data[pos + 7] << 24));

      if (pos + 8 + chunkSize > data.length) break;

      final valueBytes = data.sublist(pos + 8, pos + 8 + chunkSize);
      final value = String.fromCharCodes(valueBytes).replaceAll('\x00', '').trim();

      switch (chunkId) {
        case 'INAM': // Title
          metadata['title'] = value;
          break;
        case 'IART': // Artist
          metadata['artist'] = value;
          break;
        case 'IPRD': // Album
          metadata['album'] = value;
          break;
        case 'IGNR': // Genre
          metadata['genre'] = value;
          break;
      }

      pos += 8 + chunkSize;
      if (chunkSize % 2 != 0) pos++;
    }
  }

  /// Parse OGG Vorbis tags
  void _parseVorbisTags(List<int> bytes, Map<String, dynamic> metadata) {
    try {
      // OGG/Vorbis parsing is complex, simplified version
      // Check for OggS page header
      if (bytes.length < 27) return;
      
      if (!(bytes[0] == 0x4F && bytes[1] == 0x67 && bytes[2] == 0x67 && bytes[3] == 0x53)) {
        return;
      }
    } catch (e) {
      print('Error parsing Vorbis tags: $e');
    }
  }
}
