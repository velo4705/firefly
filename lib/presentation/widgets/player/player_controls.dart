import 'package:flutter/material.dart';
import 'package:firefly/presentation/providers/audio_player_provider.dart';
import 'package:firefly/core/utils/provider_wrapper.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Provider.of<AudioPlayerProvider>(context),
      builder: (context, child) {
        final provider = Provider.of<AudioPlayerProvider>(context);
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Progress bar
              _ProgressBar(
                position: provider.position,
                duration: provider.duration,
                onSeek: (position) => provider.seekTo(position),
              ),
              
              const SizedBox(height: 16),
              
              // Time labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(provider.position),
                    style: const TextStyle(
                      color: Color(0xFFB3B3B3),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    _formatDuration(provider.duration),
                    style: const TextStyle(
                      color: Color(0xFFB3B3B3),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Main controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Shuffle button
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.shuffle,
                      color: provider.playbackMode == PlaybackMode.shuffle
                          ? const Color(0xFFFFB300)
                          : const Color(0xFFB3B3B3),
                    ),
                  ),
                  
                  // Previous button
                  IconButton(
                    onPressed: provider.skipToPrevious,
                    icon: const Icon(
                      Icons.skip_previous,
                      color: Color(0xFFB3B3B3),
                      size: 32,
                    ),
                  ),
                  
                  // Play/Pause button
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFB300),
                    ),
                    child: IconButton(
                      onPressed: provider.togglePlayPause,
                      icon: provider.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
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
                              size: 32,
                            ),
                    ),
                  ),
                  
                  // Next button
                  IconButton(
                    onPressed: provider.skipToNext,
                    icon: const Icon(
                      Icons.skip_next,
                      color: Color(0xFFB3B3B3),
                      size: 32,
                    ),
                  ),
                  
                  // Repeat button
                  IconButton(
                    onPressed: provider.togglePlaybackMode,
                    icon: Icon(
                      provider.playbackMode == PlaybackMode.repeatOne
                          ? Icons.repeat_one
                          : Icons.repeat,
                      color: provider.playbackMode != PlaybackMode.repeat
                          ? const Color(0xFFB3B3B3)
                          : const Color(0xFFFFB300),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
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
        height: 4,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(2),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFB300),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}