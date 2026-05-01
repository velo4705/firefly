import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:firefly/presentation/bloc/local/local_music_bloc.dart';
import 'package:firefly/presentation/providers/audio_player_provider.dart';
import 'package:firefly/domain/entities/track.dart';
import 'package:firefly/presentation/widgets/cards/local_track_card.dart';
import 'package:firefly/presentation/widgets/player/mini_player.dart';
import 'package:firefly/presentation/pages/player/now_playing_page.dart';
import 'package:firefly/presentation/pages/local/directory_selection_page.dart';
import 'package:firefly/data/repositories/local_repository_impl.dart';
import 'package:firefly/domain/usecases/local/scan_local_music_usecase.dart';
import 'package:firefly/data/models/track_model.dart';

class LocalMusicPage extends StatefulWidget {
  const LocalMusicPage({super.key});

  @override
  State<LocalMusicPage> createState() => _LocalMusicPageState();
}

class _LocalMusicPageState extends State<LocalMusicPage> {
  late LocalMusicBloc _localBloc;
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
    _audioProvider = AudioPlayerProvider();
    
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
            ChangeNotifierProvider.value(value: _audioProvider),
          ],
          child: const DirectorySelectionPage(),
        ),
      ),
    );

    if (result == true) {
      _localBloc.add(LoadLocalTracksEvent());
    }
  }

  void _playTrack(Track track) {
    _audioProvider.loadTrack(track);
    _audioProvider.play();
    _localBloc.add(PlayTrackEvent(track));

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NowPlayingPage(),
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
        ChangeNotifierProvider.value(value: _audioProvider),
      ],
      child: BlocProvider.value(
        value: _localBloc,
        child: BlocBuilder<LocalMusicBloc, LocalMusicState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Local Music'),
                backgroundColor: const Color(0xFF1E1E1E),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.folder_open),
                    onPressed: _selectDirectory,
                  ),
                ],
              ),
              body: _buildContent(state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(LocalMusicState state) {
    if (state is LocalMusicLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is LocalMusicScanning) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is LocalMusicScanSuccess) {
      return _buildTrackList(state.tracks);
    } else if (state is LocalMusicScanFailure) {
      return Center(child: Text('Error: ${state.error}', style: const TextStyle(color: Colors.white)));
    } else if (state is LocalMusicLoaded) {
      return _buildTrackList(state.tracks);
    } else if (state is LocalMusicFailure) {
      return Center(child: Text('Error: ${state.error}', style: const TextStyle(color: Colors.white)));
    } else if (state is TrackSelected || state is TrackPlaying || state is TrackPaused) {
      return _buildTrackList(state is TrackSelected ? [] : []);
    } else {
      return _buildTrackList([]);
    }
  }
}
