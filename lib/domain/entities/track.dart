class Track {
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
  final int playCount;
  final DateTime? lastPlayed;
  final bool isFavorite;

  const Track({
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
    int? playCount,
    DateTime? lastPlayed,
    bool? isFavorite,
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
      playCount: playCount ?? this.playCount,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
