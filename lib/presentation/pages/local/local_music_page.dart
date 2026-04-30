import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:firefly/presentation/bloc/local/local_music_bloc.dart';
import 'package:firefly/presentation/bloc/local/local_music_event.dart';
import 'package:firefly/presentation/bloc/local/local_music_state.dart';
import 'package:firefly/presentation/providers/audio_player_provider.dart';
import 'package:firefly/presentation/providers/local_music_provider.dart';
import 'package:firefly/domain/entities/track.dart';
import 'package:firefly/presentation/widgets/cards/local_track_card.dart';
import 'package:firefly/presentation/widgets/player/mini_player.dart';
import 'package:firefly/presentation/pages/player/now_playing_page.dart';
import 'package:firefly/presentation/pages/local/directory_selection_page.dart';
import 'package:firefly/core/utils/provider_wrapper.dart';

class LocalMusicPage extends StatefulWidget {
  const LocalMusicPage({super.key});

  @override
  State<LocalMusicPage> createState() => _LocalMusicPageState();
}

class _LocalMusicPageState extends State<LocalMusicPage> {
  late LocalMusicBloc _localBloc;
  late LocalMusicProvider _localProvider;
  late AudioPlayerProvider _audioProvider;

  @override
  void initState() {
    super.initState();
    _localBloc = LocalMusicBloc(
      scanLocalMusicUsecase: ScanLocalMusicUsecase(
        LocalRepositoryImpl(),
      ),
      repository: LocalRepositoryImpl(),
    );
    _localProvider = LocalMusicProvider();
    _audioProvider = AudioPlayerProvider();
    
    // Load existing tracks on init
    _localBloc.add(LoadLocalTracksEvent());
  }

  @override
  void dispose() {
    _localBloc.close();
    super.dispose();
  }

  Future<void> _selectDirectory() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: _localProvider),
            ChangeNotifierProvider.value(value: _audioProvider),
          ],
          child: const DirectorySelectionPage(),
        ),
      ),
    );

    if (result == true) {
      // Refresh tracks after scanning
      _localBloc.add(LoadLocalTracksEvent());
    }
  }

  void _playTrack(Track track) {
    _audioProvider.loadTrack(track);
    _audioProvider.play();
    _localBloc.add(PlayTrackEvent(track));

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NowPlayingPage(),
      ),
    );
  }

  Widget _buildTrackList(List<Track> tracks) {
    if (tracks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.music_note,
              size: 64,
              color: Color(0xFFB3B3B3),
            ),
            const SizedBox(height: 16),
            const Text(
              'No local music found',
              style: TextStyle(
                color: Color(0xFFB3B3B3),
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select a folder to scan for music files',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _selectDirectory,
              icon: const Icon(Icons.folder_open),
              label: const Text('Select Folder'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB300),
                foregroundColor: const Color(0xFF121212),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        final track = tracks[index];
        return LocalTrackCard(
          track: track,
          onTap: () => _playTrack(track),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _localProvider),
        ChangeNotifierProvider.value(value: _audioProvider),
      ],
      child: BlocProvider.value(
        value: _localBloc,
        child: BlocBuilder<LocalMusicBloc, LocalMusicState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Local Music'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.folder_open),
                    onPressed: _selectDirectory,
                  ),
                  if (state is LocalMusicLoaded && state.tracks.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: _LocalMusicSearchDelegate(
                            tracks: state.tracks,
                            onTrackSelected: _playTrack,
                          ),
                        );
                      },
                    ),
                ],
              ),
              body: Column(
                children: [
                  // Mini player at the top
                  Consumer<AudioPlayerProvider>(
                    builder: (context, provider, child) {
                      return AnimatedBuilder(
                        animation: provider,
                        builder: (context, child) {
                          if (provider.currentTrack == null) {
                            return const SizedBox.shrink();
                          }
                          return MiniPlayer(audioPlayer: provider);
                        },
                      );
                    },
                  ),

                  // Bloc builder for loading/loaded states
                  Expanded(
                    child: _buildStateWidget(state),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStateWidget(LocalMusicState state) {
    if (state is LocalMusicInitial) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFB300)),
        ),
      );
    } else if (state is LocalMusicLoading || state is LocalMusicScanning) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFB300)),
            ),
            SizedBox(height: 16),
            Text(
              'Scanning for music files...',
              style: TextStyle(
                color: Color(0xFFB3B3B3),
              ),
            ),
          ],
        ),
      );
    } else if (state is LocalMusicScanSuccess) {
      return _buildScanSuccess(state);
    } else if (state is LocalMusicLoaded) {
      return _buildTrackList(state.tracks);
    } else if (state is LocalMusicScanFailure || state is LocalMusicFailure) {
      final error = (state is LocalMusicScanFailure)
          ? state.error
          : (state as LocalMusicFailure).error;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Color(0xFFFF5252),
            ),
            const SizedBox(height: 16),
            Text(
              error,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _selectDirectory,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else if (state is TrackSelected) {
      return _buildTrackList([state.track]);
    } else if (state is TrackPlaying) {
      return _buildTrackList([state.track]);
    } else {
      return _buildTrackList([]);
    }
  }

  Widget _buildScanSuccess(LocalMusicScanSuccess state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            size: 64,
            color: Color(0xFFFFB300),
          ),
          const SizedBox(height: 16),
          Text(
            'Found ${state.tracks.length} tracks',
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _localBloc.add(LoadLocalTracksEvent()),
            icon: const Icon(Icons.refresh),
            label: const Text('Load Tracks'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFB300),
              foregroundColor: const Color(0xFF121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocalMusicSearchDelegate extends SearchDelegate<Track> {
  final List<Track> tracks;
  final Function(Track) onTrackSelected;

  _LocalMusicSearchDelegate({
    required this.tracks,
    required this.onTrackSelected,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, tracks.first);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = tracks
        .where((track) =>
            track.title.toLowerCase().contains(query.toLowerCase()) ||
            track.artist.toLowerCase().contains(query.toLowerCase()) ||
            track.album.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final track = results[index];
        return ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFFB300).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.music_note,
              color: Color(0xFFFFB300),
              size: 24,
            ),
          ),
          title: Text(
            track.title,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            '${track.artist} - ${track.album}',
            style: const TextStyle(color: Color(0xFFB3B3B3)),
          ),
          onTap: () {
            onTrackSelected(track);
            close(context, track);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = tracks
        .where((track) =>
            track.title.toLowerCase().contains(query.toLowerCase()) ||
            track.artist.toLowerCase().contains(query.toLowerCase()))
        .take(5)
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final track = suggestions[index];
        return ListTile(
          title: Text(
            track.title,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            track.artist,
            style: const TextStyle(color: Color(0xFFB3B3B3)),
          ),
          onTap: () {
            query = track.title;
            showResults(context);
          },
        );
      },
    );
  }
}
