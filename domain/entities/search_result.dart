import 'package:equatable/equatable.dart';

class SearchResult extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String type; // track, album, artist, playlist
  final String service; // spotify, youtube, local
  final String? coverArt;
  final String? album;
  final int? duration;
  final int? trackCount;
  final int? popularity;

  const SearchResult({
    required this.id,
    required this.title,
    required this.artist,
    required this.type,
    required this.service,
    this.coverArt,
    this.album,
    this.duration,
    this.trackCount,
    this.popularity,
  });

  factory SearchResult.fromTrack(Track track, String service) {
    return SearchResult(
      id: track.id,
      title: track.title,
      artist: track.artist,
      type: 'track',
      service: service,
      album: track.album,
      duration: track.duration.inMilliseconds,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        artist,
        type,
        service,
      ];

  SearchResult copyWith({
    String? id,
    String? title,
    String? artist,
    String? type,
    String? service,
    String? coverArt,
    String? album,
    int? duration,
    int? trackCount,
    int? popularity,
  }) {
    return SearchResult(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      type: type ?? this.type,
      service: service ?? this.service,
      coverArt: coverArt ?? this.coverArt,
      album: album ?? this.album,
      duration: duration ?? this.duration,
      trackCount: trackCount ?? this.trackCount,
      popularity: popularity ?? this.popularity,
    );
  }
}
