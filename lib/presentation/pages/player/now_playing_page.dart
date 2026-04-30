import 'package:flutter/material.dart';
import 'package:firefly/presentation/providers/audio_player_provider.dart';
import 'package:firefly/presentation/widgets/player/player_controls.dart';
import 'package:firefly/core/utils/provider_wrapper.dart';
import 'package:firefly/presentation/widgets/player/audio_visualizer.dart';

class NowPlayingPage extends StatelessWidget {
  const NowPlayingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Provider.of<AudioPlayerProvider>(context),
      builder: (context, child) {
        final provider = Provider.of<AudioPlayerProvider>(context);
        
        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          appBar: AppBar(
            backgroundColor: const Color(0xFF121212),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.keyboard_arrow_down),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('Now Playing'),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
          body: provider.currentTrack == null
              ? const Center(
                  child: Text(
                    'No track selected',
                    style: TextStyle(
                      color: Color(0xFFB3B3B3),
                      fontSize: 18,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      
                      // Album art with visualizer
                      Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB300).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFB300).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: provider.isPlaying
                            ? AudioVisualizer(
                                bars: 48,
                                spacing: 3,
                                minHeight: 4,
                                maxHeight: 60,
                                width: 280,
                                color: const Color(0xFFFFB300),
                                playerState: PlayerState.playing,
                                position: provider.position,
                                duration: provider.duration,
                              )
                            : const Icon(
                                Icons.music_note,
                                color: Color(0xFFFFB300),
                                size: 80,
                              ),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Track info
                      Text(
                        provider.currentTrack!.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      Text(
                        provider.currentTrack!.artist,
                        style: const TextStyle(
                          color: Color(0xFFB3B3B3),
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        provider.currentTrack!.album,
                        style: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Player controls
                      const PlayerControls(),
                      
                      const SizedBox(height: 32),
                      
                      // Volume control
                      _VolumeControl(
                        volume: provider.volume,
                        isMuted: provider.isMuted,
                        onVolumeChanged: provider.setVolume,
                        onMuteToggled: provider.toggleMute,
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _VolumeControl extends StatelessWidget {
  final double volume;
  final bool isMuted;
  final Function(double) onVolumeChanged;
  final VoidCallback onMuteToggled;

  const _VolumeControl({
    required this.volume,
    required this.isMuted,
    required this.onVolumeChanged,
    required this.onMuteToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Mute button
        IconButton(
          onPressed: onMuteToggled,
          icon: Icon(
            isMuted || volume == 0
                ? Icons.volume_off
                : volume < 0.5
                    ? Icons.volume_down
                    : Icons.volume_up,
            color: const Color(0xFFB3B3B3),
          ),
        ),
        
        // Volume slider
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFFFB300),
              inactiveTrackColor: const Color(0xFF2A2A2A),
              thumbColor: const Color(0xFFFFB300),
              overlayColor: const Color(0xFFFFB300).withOpacity(0.2),
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            ),
            child: Slider(
              value: isMuted ? 0.0 : volume,
              min: 0.0,
              max: 1.0,
              onChanged: onVolumeChanged,
            ),
          ),
        ),
        
        // Volume percentage
        SizedBox(
          width: 40,
          child: Text(
            '${((isMuted ? 0.0 : volume) * 100).round()}%',
            style: const TextStyle(
              color: Color(0xFFB3B3B3),
              fontSize: 12,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
