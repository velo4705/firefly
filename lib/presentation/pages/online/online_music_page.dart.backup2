import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firefly/presentation/bloc/search/search_bloc.dart';


import 'package:firefly/data/datasources/remote/spotify_api.dart';
import 'package:firefly/data/datasources/remote/youtube_music_api.dart';
import 'package:firefly/presentation/widgets/cards/track_card.dart';
import 'package:firefly/presentation/widgets/cards/album_card.dart';
import 'package:firefly/presentation/widgets/cards/artist_card.dart';
import 'package:firefly/presentation/widgets/cards/playlist_card.dart';
import 'package:firefly/presentation/widgets/player/mini_player.dart';
import 'package:firefly/presentation/providers/audio_player_provider.dart';
import 'package:provider/provider.dart';
import 'package:firefly/presentation/pages/player/now_playing_page.dart';
import 'package:firefly/domain/entities/track.dart';
import 'package:firefly/domain/entities/search_result.dart';
import 'package:firefly/data/repositories/search_repository_impl.dart';

class OnlineMusicPage extends StatefulWidget {
  const OnlineMusicPage({super.key});

  @override
  State<OnlineMusicPage> createState() => _OnlineMusicPageState();
}

class _OnlineMusicPageState extends State<OnlineMusicPage> with SingleTickerProviderStateMixin {
  late final SearchBloc _searchBloc;
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchBloc = SearchBloc(
      repository: SearchRepositoryImpl(
        spotifyApi: SpotifyApi(),
        youtubeMusicApi: YouTubeMusicApi(),
      ),
    );
    _tabController = TabController(length: 4, vsync: this);
    _loadTrending();
  }

  @override
  void dispose() {
    _searchBloc.close();
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadTrending() {
    _searchBloc.add(GetTrendingEvent());
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchQuery = '';
      });
      _searchBloc.add(ClearSearchEvent());
      return;
    }

    setState(() {
      _searchQuery = query;
      _isSearching = true;
    });

    switch (_tabController.index) {
      case 0:
        _searchBloc.add(SearchTracksEvent(query));
        break;
      case 1:
        _searchBloc.add(SearchAlbumsEvent(query));
        break;
      case 2:
        _searchBloc.add(SearchArtistsEvent(query));
        break;
      case 3:
        _searchBloc.add(SearchPlaylistsEvent(query));
        break;
    }
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0xFFB3B3B3), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search Music',
                hintStyle: TextStyle(color: Color(0xFF666666)),
                border: InputBorder.none,
                isDense: true,
              ),
              onSubmitted: _performSearch,
              onChanged: (value) {
                if (value.isEmpty) {
                  _performSearch('');
                }
              },
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Color(0xFFB3B3B3), size: 20),
              onPressed: () {
                _searchController.clear();
                _performSearch('');
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: const Color(0xFF121212),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Tracks'),
          Tab(text: 'Albums'),
          Tab(text: 'Artists'),
          Tab(text: 'Playlists'),
        ],
        indicatorColor: const Color(0xFFFFB300),
        indicatorWeight: 3,
        labelColor: const Color(0xFFFFB300),
        unselectedLabelColor: const Color(0xFFB3B3B3),
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 13),
        isScrollable: true,
        onTap: (index) {
          if (_searchQuery.isNotEmpty) {
            _performSearch(_searchQuery);
          }
        },
      ),
    );
  }

  Widget _buildResultItem(SearchResult result, String type) {
    switch (type) {
      case 'tracks':
        return TrackCard(
          title: result.title,
          artist: result.artist,
          album: result.album ?? '',
          duration: result.duration != null
              ? Duration(milliseconds: result.duration!)
              : Duration.zero,
          coverArt: result.coverArt,
          onTap: () {
            // For demo, create a track from search result
            final track = Track(
              id: result.id,
              title: result.title,
              artist: result.artist,
              album: result.album ?? '',
              filePath: '',
              duration: result.duration != null
                  ? Duration(milliseconds: result.duration!)
                  : Duration.zero,
              fileSize: 0,
              createdAt: DateTime.now(),
            );

            final audioProvider = Provider.of<AudioPlayerProvider>(
              context,
              listen: false,
            );

            audioProvider.loadTrack(track);
            audioProvider.play();

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const NowPlayingPage(),
              ),
            );
          },
        );
      case 'albums':
        return AlbumCard(
          title: result.title,
          artist: result.artist,
          coverArt: result.coverArt,
          onTap: () {
            // Handle album tap
          },
        );
      case 'artists':
        return ArtistCard(
          name: result.title,
          coverArt: result.coverArt,
          onTap: () {
            // Handle artist tap
          },
        );
      case 'playlists':
        return PlaylistCard(
          title: result.title,
          subtitle: result.artist,
          trackCount: result.trackCount ?? 0,
          coverArt: result.coverArt,
          onTap: () {
            // Handle playlist tap
          },
        );
      default:
        return ListTile(
          title: Text(
            result.title,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            result.artist,
            style: const TextStyle(color: Color(0xFFB3B3B3)),
          ),
        );
    }
  }

  Widget _buildBody(SearchState state) {
    if (!_isSearching) {
      return BlocBuilder<SearchBloc, SearchState>(
        bloc: _searchBloc,
        builder: (context, trendingState) {
          if (trendingState is TrendingLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8),
              itemCount: trendingState.results.length,
              itemBuilder: (context, index) {
                final result = trendingState.results[index];
                return _buildResultItem(result, 'tracks');
              },
            );
          } else if (trendingState is SearchLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFB300)),
              ),
            );
          } else {
            return const Center(
              child: Text(
                'Trending songs will appear here',
                style: TextStyle(color: Color(0xFF666666)),
              ),
            );
          }
        },
      );
    }

    if (state is SearchInitial) {
      return const Center(
        child: Text(
          'Search results will appear here',
          style: TextStyle(color: Color(0xFF666666)),
        ),
      );
    } else if (state is SearchLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFB300)),
            ),
            SizedBox(height: 16),
            Text(
              'Searching...',
              style: TextStyle(color: Color(0xFFB3B3B3)),
            ),
          ],
        ),
      );
    } else if (state is SearchLoaded) {
      if (state.results.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.music_note, size: 64, color: Color(0xFF666666)),
              const SizedBox(height: 16),
              Text(
                'No results found',
                style: const TextStyle(color: Color(0xFFB3B3B3)),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.only(top: 8),
        itemCount: state.results.length,
        itemBuilder: (context, index) {
          final result = state.results[index];
          return _buildResultItem(result, state.type);
        },
      );
    } else if (state is SearchError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Color(0xFFFF5252)),
            const SizedBox(height: 16),
            const Text('Search failed', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            Text(state.error, style: const TextStyle(color: Color(0xFFB3B3B3))),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Online Music'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Mini player at the top
          Consumer<AudioPlayerProvider>(
            builder: (context, audioProvider, child) {
              return AnimatedBuilder(
                animation: audioProvider,
                builder: (context, child) {
                  if (audioProvider.currentTrack == null) {
                    return const SizedBox.shrink();
                  }
                  return MiniPlayer(audioPlayer: audioProvider);
                },
              );
            },
          ),

          // Search bar
          _buildSearchBar(),

          // Tab bar
          _buildTabBar(),

          // Search results
          Expanded(
            child: MultiProvider(
              providers: [
                Provider.value(value: Provider.of<AudioPlayerProvider>(context)),
              ],
              child: BlocProvider.value(
                value: _searchBloc,
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    return _buildBody(state);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
