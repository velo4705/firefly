import 'package:firefly/domain/entities/track.dart';

class SearchResult {
  final String id;
  final String title;
  final String artist;
  final String type;
  final String? imageUrl;
  final String? album;
  final Duration? duration;
  final String? service;
  final int? trackCount;

  const SearchResult({
    required this.id,
    required this.title,
    required this.artist,
    required this.type,
    this.imageUrl,
    this.album,
    this.duration,
    this.service,
    this.trackCount,
  });

  factory SearchResult.fromTrack(Track track, String service) {
    return SearchResult(
      id: track.id,
      title: track.title,
      artist: track.artist,
      type: 'track',
      imageUrl: '',
      album: track.album,
      duration: track.duration,
      service: service,
    );
  }
}
