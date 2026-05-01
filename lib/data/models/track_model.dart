import 'package:hive/hive.dart';
import 'package:path/path.dart' as p;
import 'package:firefly/domain/entities/track.dart';

part 'track_model.g.dart';

@HiveType(typeId: 0)
class TrackModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String artist;

  @HiveField(3)
  final String album;

  @HiveField(4)
  final String filePath;

  @HiveField(5)
  final int duration;

  @HiveField(6)
  final int fileSize;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final String genre;

  @HiveField(9)
  final int bitrate;

  @HiveField(10)
  final int sampleRate;

  @HiveField(11)
  final int channels;

  @HiveField(12)
  int playCount;

  @HiveField(13)
  DateTime? lastPlayed;

  @HiveField(14)
  bool isFavorite;

  TrackModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.filePath,
    required this.duration,
    required this.fileSize,
    required this.createdAt,
    required this.genre,
    required this.bitrate,
    required this.sampleRate,
    required this.channels,
    this.playCount = 0,
    this.lastPlayed,
    this.isFavorite = false,
  });

  TrackModel copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? filePath,
    int? duration,
    int? fileSize,
    DateTime? createdAt,
    String? genre,
    int? bitrate,
    int? sampleRate,
    int? channels,
    int? playCount,
    DateTime? lastPlayed,
    bool? isFavorite,
  }) {
    return TrackModel(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      filePath: filePath ?? this.filePath,
      duration: duration ?? this.duration,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
      genre: genre ?? this.genre,
      bitrate: bitrate ?? this.bitrate,
      sampleRate: sampleRate ?? this.sampleRate,
      channels: channels ?? this.channels,
      playCount: playCount ?? this.playCount,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory TrackModel.fromTrack(Track track) {
    return TrackModel(
      id: track.id,
      title: track.title,
      artist: track.artist,
      album: track.album,
      filePath: track.filePath,
      duration: track.duration.inMilliseconds,
      fileSize: track.fileSize,
      createdAt: track.createdAt,
      genre: track.genre,
      bitrate: track.bitrate,
      sampleRate: track.sampleRate,
      channels: track.channels,
    );
  }

  Track toTrack() {
    return Track(
      id: id,
      title: title,
      artist: artist,
      album: album,
      filePath: filePath,
      duration: Duration(milliseconds: duration),
      fileSize: fileSize,
      createdAt: createdAt,
      genre: genre,
      bitrate: bitrate,
      sampleRate: sampleRate,
      channels: channels,
      playCount: playCount,
      lastPlayed: lastPlayed,
      isFavorite: isFavorite,
    );
  }
}
