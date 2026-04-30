import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firefly/presentation/providers/audio_player_provider.dart';
import 'package:firefly/presentation/widgets/player/player_controls.dart';
import 'package:firefly/presentation/widgets/player/audio_visualizer.dart';
import 'package:firefly/presentation/widgets/player/queue_manager.dart';
import 'package:firefly/presentation/widgets/player/gesture_controls.dart';
import 'package:firefly/domain/entities/track.dart';

/// Enhanced Now Playing Screen with full visual polish
class EnhancedNowPlayingPage extends StatefulWidget {
  final Track? initialTrack;

  const EnhancedNowPlayingPage({
    super.key,
    this.initialTrack,
  });

  @override
  State<EnhancedNowPlayingPage> createState() => _EnhancedNowPlayingPageState();
}

class _EnhancedNowPlayingPageState extends State<EnhancedNowPlayingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _particleController;
  List<FireflyParticle> _particles = [];
  bool _showLyrics = false;
  bool _showEqualizer = false;

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _initializeParticles();
  }

  void _initializeParticles() {
    _particles = List.generate(20, (index) {
      return FireflyParticle(
        position: Offset(
          (index * 37.0) % 300 + 50,
          (index * 53.0) % 400 + 50,
        ),
        velocity: Offset(
          (index % 3 - 1).toDouble() * 10,
          (index % 5 - 2).toDouble() * 10,
        ),
        size: (index % 3 + 1).toDouble(),
        color: index % 2 == 0
            ? const Color(0xFFFFB300)
            : const Color(0xFFFF6F00),
        opacity: 0.5 + (index % 3) * 0.2,
      );
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerProvider, AudioPlayerProvider>(
      builder: (context, provider) {
        return Scaffold(
          backgroundColor: const Color(0xFF0A0A0A),
          extendBodyBehindAppBar: true,
          body: GestureDetector(
            onVerticalDragUpdate: (details) {
              // Swipe down to close
              if (details.primaryDelta! > 5) {
                Navigator.of(context).pop();
              }
            },
            child: Stack(
              children: [
                // Animated background
                _buildAnimatedBackground(),

                // Main content
                SafeArea(
                  child: Column(
                    children: [
                      // App bar
                      _buildAppBar(context),

                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              // Album art with visualizer
                              _buildAlbumArtSection(provider),

                              // Track info
                              _buildTrackInfo(provider),

                              // Lyrics or Equalizer
                              _showLyrics
                                  ? _buildLyricsSection()
                                  : _showEqualizer
                                      ? _buildEqualizerSection(provider)
                                      : _buildActionsRow(),

                              const SizedBox(height: 24),

                              // Progress bar
                              _buildEnhancedProgressBar(provider),

                              const SizedBox(height: 32),

                              // Main controls
                              const PlayerControls(),

                              const SizedBox(height: 24),

                              // Queue preview
                              if (provider.queue.isNotEmpty)
                                _buildQueuePreview(context, provider),

                              const SizedBox(height: 32),

                              // Volume control
                              _buildEnhancedVolumeControl(provider),

                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),

                      // Bottom player bar
                      _buildBottomBar(provider),
                    ],
                  ),
                ),

                // Mini floating visualizer
                _buildFloatingVisualizer(provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return CustomPaint(
          painter: FireflyBackgroundPainter(_particles),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  _showLyrics
                      ? Icons.waves
                      : _showEqualizer
                          ? Icons.equalizer
                          : Icons.lyrics,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    if (!_showLyrics && !_showEqualizer) {
                      _showLyrics = true;
                    } else if (_showLyrics) {
                      _showLyrics = false;
                      _showEqualizer = true;
                    } else {
                      _showEqualizer = false;
                    }
                  });
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {
                  // Show more options
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumArtSection(AudioPlayerProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        children: [
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFFB300).withOpacity(0.4),
                  const Color(0xFFFF6F00).withOpacity(0.2),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
                center: const Alignment(0.2, -0.2),
              ),
            ),
            child: Center(
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1A1A1A),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: provider.isPlaying
                    ? AudioVisualizer(
                        bars: 48,
                        spacing: 2,
                        minHeight: 3,
                        maxHeight: 45,
                        width: 240,
                        color: const Color(0xFFFFB300),
                        playerState: PlayerState.playing,
                        position: provider.position,
                        duration: provider.duration,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.music_note,
                            size: 80,
                            color: const Color(0xFFFFB300).withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            provider.currentTrack?.title ?? 'Select a track',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackInfo(AudioPlayerProvider provider) {
    return Column(
      children: [
        Text(
          provider.currentTrack?.title ?? 'Unknown Track',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          provider.currentTrack?.artist ?? 'Unknown Artist',
          style: const TextStyle(
            color: Color(0xFFB3B3B3),
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          provider.currentTrack?.album ?? '',
          style: const TextStyle(
            color: Color(0xFF666666),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLyricsSection() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Lyrics',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.info_outline, color: Color(0xFFB3B3B3), size: 18),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '[Verse 1]\nFirefly dancing in the night\nGolden sparks of pure delight\nOrange glow against the dark\nTiny beacons, leave their mark',
            style: const TextStyle(
              color: Color(0xFFB3B3B3),
              fontSize: 16,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const LinearProgressIndicator(
            value: 0.4,
            backgroundColor: Color(0xFF2A2A2A),
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFB300)),
          ),
        ],
      ),
    );
  }

  Widget _buildEqualizerSection(AudioPlayerProvider provider) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        children: [
          const Text(
            'Equalizer',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(8, (index) {
              final height = 20 + (index * 15) % 60;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 16,
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFFB300).withOpacity(0.8),
                      const Color(0xFFFFB300).withOpacity(0.3),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(Icons.favorite_border, 'Like'),
        _buildActionButton(Icons.download, 'Download'),
        _buildActionButton(Icons.share, 'Share'),
        _buildActionButton(Icons.add, 'Add to Queue'),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFFB3B3B3), size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFB3B3B3),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedProgressBar(AudioPlayerProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
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
          const SizedBox(height: 8),
          GestureDetector(
            onTapDown: (details) {
              final box = context.findRenderObject() as RenderBox;
              final localDx = box.globalToLocal(details.globalPosition).dx;
              final percentage = localDx / box.size.width;
              provider.seekTo(Duration(
                milliseconds: (provider.duration.inMilliseconds * percentage)
                    .round(),
              ));
            },
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: provider.progress,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFFB300),
                        Color(0xFFFF6F00),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueuePreview(BuildContext context, AudioPlayerProvider provider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Up Next',
                  style: TextStyle(
                    color: Color(0xFFB3B3B3),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  provider.queue.length > 1
                      ? provider.queue[1].title
                      : 'End of Queue',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: const Color(0xFF121212),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (context) => QueueBottomSheet(
                  audioPlayer: provider,
                  queue: provider.queue,
                ),
              );
            },
            child: const Text(
              'View Full Queue',
              style: TextStyle(
                color: Color(0xFFFFB300),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedVolumeControl(AudioPlayerProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Icon(
            provider.isMuted || provider.volume == 0
                ? Icons.volume_off
                : provider.volume < 0.5
                    ? Icons.volume_down
                    : Icons.volume_up,
            color: const Color(0xFFB3B3B3),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: const Color(0xFFFFB300),
                inactiveTrackColor: const Color(0xFF2A2A2A),
                thumbColor: const Color(0xFFFFB300),
                overlayColor: const Color(0xFFFFB300).withOpacity(0.2),
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              ),
              child: Slider(
                value: provider.isMuted ? 0.0 : provider.volume,
                min: 0.0,
                max: 1.0,
                onChanged: provider.setVolume,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${(provider.volume * 100).round()}%',
            style: const TextStyle(
              color: Color(0xFFB3B3B3),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(AudioPlayerProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            const Color(0xFF0A0A0A),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.play_arrow,
              color: Color(0xFFFFB300),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Firefly Spectrum',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Visual Audio Experience',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.expand_more,
            color: Color(0xFFB3B3B3),
            size: 28,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingVisualizer(AudioPlayerProvider provider) {
    if (!provider.isPlaying) return const SizedBox.shrink();

    return Positioned(
      bottom: 100,
      right: 20,
      child: MiniAudioVisualizer(audioPlayer: provider),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
