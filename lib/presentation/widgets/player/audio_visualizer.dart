import 'package:flutter/material.dart';
import 'package:firefly/presentation/providers/audio_player_provider.dart';
import 'package:flutter/material.dart';

class AudioVisualizer extends StatelessWidget {
  final int bars;
  final double spacing;
  final double minHeight;
  final double maxHeight;
  final double width;
  final Color color;
  final PlayerState playerState;
  final Duration position;
  final Duration duration;

  const AudioVisualizer({
    super.key,
    this.bars = 64,
    this.spacing = 3,
    this.minHeight = 2,
    this.maxHeight = 20,
    this.width = 200,
    this.color = const Color(0xFFFFB300),
    required this.playerState,
    required this.position,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: maxHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(bars, (index) {
          return AnimatedBar(
            index: index,
            bars: bars,
            spacing: spacing,
            minHeight: minHeight,
            maxHeight: maxHeight,
            color: color,
            playerState: playerState,
            position: position,
            duration: duration,
          );
        }),
      ),
    );
  }
}

class AnimatedBar extends StatelessWidget {
  final int index;
  final int bars;
  final double spacing;
  final double minHeight;
  final double maxHeight;
  final Color color;
  final PlayerState playerState;
  final Duration position;
  final Duration duration;

  const AnimatedBar({
    super.key,
    required this.index,
    required this.bars,
    required this.spacing,
    required this.minHeight,
    required this.maxHeight,
    required this.color,
    required this.playerState,
    required this.position,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    double progress = 0.0;
    if (duration.inMilliseconds > 0) {
      progress = position.inMilliseconds / duration.inMilliseconds;
    }

    // Create a wave-like animation based on position
    double barHeight;
    if (playerState == PlayerState.playing) {
      // Simulated audio spectrum using sine wave + progress
      final wavePhase = (position.inMilliseconds / 100.0) + (index * 0.5);
      final sineValue = (sin(wavePhase) + 1) / 2; // 0 to 1
      final progressInfluence = 0.3 + (progress * 0.7); // Varies with song progress
      barHeight = minHeight + (maxHeight - minHeight) * sineValue * progressInfluence;
    } else if (playerState == PlayerState.paused) {
      // Static bars when paused
      final staticValue = (index / bars) * 0.5 + 0.5;
      barHeight = minHeight + (maxHeight - minHeight) * staticValue * 0.3;
    } else {
      // Idle state - minimal height
      barHeight = minHeight;
    }

    return Container(
      width: (60 - spacing * (bars - 1)) / bars,
      height: barHeight,
      margin: EdgeInsets.symmetric(horizontal: spacing / 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.7 + (index % 3) * 0.1),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class FireflyAudioVisualizer extends StatelessWidget {
  final AudioPlayerProvider audioPlayer;

  const FireflyAudioVisualizer({
    super.key,
    required this.audioPlayer,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: audioPlayer,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E).withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFFFB300).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Firefly Spectrum',
                style: TextStyle(
                  color: Color(0xFFB3B3B3),
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              AudioVisualizer(
                bars: 32,
                spacing: 2,
                minHeight: 3,
                maxHeight: 25,
                width: 180,
                color: const Color(0xFFFFB300),
                playerState: audioPlayer.isPlaying
                    ? PlayerState.playing
                    : PlayerState.paused,
                position: audioPlayer.position,
                duration: audioPlayer.duration,
              ),
              const SizedBox(height: 12),
              if (audioPlayer.currentTrack != null)
                Text(
                  audioPlayer.currentTrack!.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        );
      },
    );
  }
}

class MiniAudioVisualizer extends StatelessWidget {
  final AudioPlayerProvider audioPlayer;

  const MiniAudioVisualizer({
    super.key,
    required this.audioPlayer,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: audioPlayer,
      builder: (context, child) {
        return SizedBox(
          width: 60,
          height: 12,
          child: AudioVisualizer(
            bars: 8,
            spacing: 1,
            minHeight: 2,
            maxHeight: 10,
            width: 60,
            color: const Color(0xFFFFB300).withOpacity(0.8),
            playerState: audioPlayer.isPlaying
                ? PlayerState.playing
                : PlayerState.paused,
            position: audioPlayer.position,
            duration: audioPlayer.duration,
          ),
        );
      },
    );
  }
}
