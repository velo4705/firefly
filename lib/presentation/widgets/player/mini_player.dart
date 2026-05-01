import 'package:flutter/material.dart';
import 'package:firefly/presentation/providers/audio_player_provider.dart';
import 'package:firefly/domain/entities/track.dart';
import 'package:firefly/presentation/widgets/player/audio_visualizer.dart';

class MiniPlayer extends StatelessWidget {
  final AudioPlayerProvider? audioPlayer;
  
  const MiniPlayer({super.key, this.audioPlayer});

  @override
  Widget build(BuildContext context) {
    final provider = audioPlayer ?? AudioPlayerProvider();
    return AnimatedBuilder(
      animation: provider,
      builder: (context, child) {
        if (provider.currentTrack == null) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Track info
              Row(
                children: [
                  // Album art placeholder
                  Container(
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
                  
                  const SizedBox(width: 12),
                  
                  // Track details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.currentTrack!.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          provider.currentTrack!.artist,
                          style: const TextStyle(
                            color: Color(0xFFB3B3B3),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Audio visualizer when playing
                  if (provider.isPlaying)
                    MiniAudioVisualizer(audioPlayer: provider),
                  if (!provider.isPlaying)
                    const SizedBox(width: 32),
                  
                  // Play/Pause button
                  GestureDetector(
                    onTap: provider.togglePlayPause,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFFB300),
                      ),
                      child: provider.isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF121212),
                                ),
                              ),
                            )
                          : Icon(
                              provider.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: const Color(0xFF121212),
                              size: 20,
                            ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Progress bar
              _ProgressBar(
                position: provider.position,
                duration: provider.duration,
                onSeek: provider.seekTo,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final Function(Duration) onSeek;

  const _ProgressBar({
    required this.position,
    required this.duration,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;

    return GestureDetector(
      onTapDown: (details) {
        final box = context.findRenderObject() as RenderBox;
        final localDx = box.globalToLocal(details.globalPosition).dx;
        final percentage = localDx / box.size.width;
        final newPosition = Duration(
          milliseconds: (duration.inMilliseconds * percentage).round(),
        );
        onSeek(newPosition);
      },
      child: Container(
        height: 3,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(1.5),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFB300),
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        ),
      ),
    );
  }
}
