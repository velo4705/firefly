import 'package:equatable/equatable.dart';

class Track extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String filePath;
  final Duration duration;
  final int fileSize;
  final DateTime createdAt;
  final String genre;
  final int bitrate;
  final int sampleRate;
  final int channels;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.filePath,
    required this.duration,
    this.fileSize = 0,
    required this.createdAt,
    this.genre = 'Unknown',
    this.bitrate = 0,
    this.sampleRate = 0,
    this.channels = 0,
  });

  Track copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? filePath,
    Duration? duration,
    int? fileSize,
    DateTime? createdAt,
    String? genre,
    int? bitrate,
    int? sampleRate,
    int? channels,
  }) {
    return Track(
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
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        artist,
        album,
        filePath,
        duration,
        fileSize,
        createdAt,
        genre,
        bitrate,
        sampleRate,
        channels,
      ];
}
