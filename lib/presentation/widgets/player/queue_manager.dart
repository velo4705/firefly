import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firefly/domain/entities/track.dart';
import 'package:firefly/presentation/providers/audio_player_provider.dart';
import 'package:firefly/presentation/widgets/cards/track_card.dart';

/// Queue Management Bottom Sheet
class QueueBottomSheet extends StatefulWidget {
  final AudioPlayerProvider audioPlayer;
  final List<Track> queue;

  const QueueBottomSheet({
    super.key,
    required this.audioPlayer,
    required this.queue,
  });

  @override
  State<QueueBottomSheet> createState() => _QueueBottomSheetState();
}

class _QueueBottomSheetState extends State<QueueBottomSheet> {
  late List<Track> _queue;
  int? _draggedIndex;
  int? _hoverIndex;

  @override
  void initState() {
    super.initState();
    _queue = List.from(widget.queue);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF121212),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3A),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Now Playing',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${_queue.length} tracks',
                      style: const TextStyle(
                        color: Color(0xFFB3B3B3),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Current track
              if (_queue.isNotEmpty)
                _buildCurrentTrack(),

              const SizedBox(height: 16),

              // Queue list
              Expanded(
                child: ReorderableListView.builder(
                  controller: scrollController,
                  itemCount: _queue.length,
                  padding: const EdgeInsets.only(bottom: 24),
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      final item = _queue.removeAt(oldIndex);
                      _queue.insert(newIndex, item);
                    });
                  },
                  itemBuilder: (context, index) {
                    final track = _queue[index];
                    final isCurrent = index == 0;

                    return Container(
                      key: ValueKey(track.id),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            _playTrackAtIndex(index);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isCurrent
                                  ? const Color(0xFFFFB300).withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isCurrent
                                    ? const Color(0xFFFFB300)
                                    : Colors.transparent,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Position
                                Container(
                                  width: 24,
                                  height: 24,
                                  alignment: Alignment.center,
                                  child: isCurrent
                                      ? const Icon(
                                          Icons.play_arrow,
                                          size: 16,
                                          color: Color(0xFFFFB300),
                                        )
                                      : Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                            color: Color(0xFF666666),
                                            fontSize: 12,
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 12),

                                // Track info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        track.title,
                                        style: TextStyle(
                                          color: isCurrent
                                              ? const Color(0xFFFFB300)
                                              : Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        track.artist,
                                        style: const TextStyle(
                                          color: Color(0xFF666666),
                                          fontSize: 12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),

                                // Duration
                                Text(
                                  _formatDuration(track.duration),
                                  style: TextStyle(
                                    color: isCurrent
                                        ? const Color(0xFFFFB300)
                                        : const Color(0xFF666666),
                                    fontSize: 12,
                                  ),
                                ),

                                const SizedBox(width: 8),

                                // Remove button
                                if (!isCurrent)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Color(0xFF666666),
                                    ),
                                    onPressed: () {
                                      _removeTrack(index);
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Actions
              if (_queue.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Shuffle
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _shuffleQueue();
                          },
                          icon: const Icon(Icons.shuffle, size: 18),
                          label: const Text('Shuffle'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF2A2A2A)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Clear
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _clearQueue();
                          },
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text('Clear'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFFF5252),
                            side: const BorderSide(color: Color(0xFFFF5252)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentTrack() {
    final currentTrack = _queue.first;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFB300).withOpacity(0.2),
            const Color(0xFFFF6F00).withOpacity(0.1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFB300).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          // Album art placeholder
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFFFB300).withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.music_note,
              color: Color(0xFFFFB300),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),

          // Track info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentTrack.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  currentTrack.artist,
                  style: const TextStyle(
                    color: Color(0xFFB3B3B3),
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Play/Pause button
          BlocBuilder<AudioPlayerProvider, AudioPlayerProvider>(
            builder: (context, provider) {
              return IconButton.filledTonal(
                onPressed: provider.togglePlayPause,
                icon: Icon(
                  provider.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: const Color(0xFF121212),
                ),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB300),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _playTrackAtIndex(int index) {
    // Logic to play track at index
    widget.audioProvider.loadTrack(_queue[index]);
    widget.audioProvider.play();
  }

  void _removeTrack(int index) {
    setState(() {
      _queue.removeAt(index);
    });
  }

  void _clearQueue() {
    setState(() {
      if (_queue.length > 1) {
        final currentTrack = _queue.first;
        _queue = [currentTrack];
      } else {
        _queue.clear();
      }
    });
  }

  void _shuffleQueue() {
    setState(() {
      if (_queue.length > 1) {
        final currentTrack = _queue.first;
        final remaining = _queue.sublist(1)..shuffle();
        _queue = [currentTrack, ...remaining];
      }
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

/// Queue Manager Page
class QueueManagerPage extends StatelessWidget {
  final List<Track> queue;

  const QueueManagerPage({
    super.key,
    required this.queue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text(
          'Play Queue',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: QueuePageContent(
        queue: queue,
        onReorder: (oldIndex, newIndex) {
          // Handle reorder
        },
      ),
    );
  }
}

/// Queue Page Content (standalone widget)
class QueuePageContent extends StatefulWidget {
  final List<Track> queue;
  final Function(int, int) onReorder;

  const QueuePageContent({
    super.key,
    required this.queue,
    required this.onReorder,
  });

  @override
  State<QueuePageContent> createState() => _QueuePageContentState();
}

class _QueuePageContentState extends State<QueuePageContent> {
  late List<Track> _queue;

  @override
  void initState() {
    super.initState();
    _queue = List.from(widget.queue);
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: _queue.length,
      padding: const EdgeInsets.all(16),
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final item = _queue.removeAt(oldIndex);
          _queue.insert(newIndex, item);
        });
        widget.onReorder(oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final track = _queue[index];
        final isCurrent = index == 0;

        return Card(
          key: ValueKey(track.id),
          color: isCurrent
              ? const Color(0xFFFFB300).withOpacity(0.1)
              : const Color(0xFF1E1E1E),
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isCurrent
                  ? const Color(0xFFFFB300)
                  : const Color(0xFF2A2A2A),
              child: Icon(
                isCurrent ? Icons.play_arrow : Icons.music_note,
                color: Colors.white,
              ),
            ),
            title: Text(
              track.title,
              style: TextStyle(
                color: isCurrent ? const Color(0xFFFFB300) : Colors.white,
                fontWeight:
                    isCurrent ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text(
              track.artist,
              style: const TextStyle(color: Color(0xFFB3B3B3)),
            ),
            trailing: Text(
              '${track.duration.inMinutes}:${(track.duration.inSeconds % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(color: Color(0xFF666666)),
            ),
          ),
        );
      },
    );
  }
}
