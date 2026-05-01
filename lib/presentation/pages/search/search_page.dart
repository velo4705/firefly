import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firefly/presentation/bloc/search/search_bloc.dart';
import 'package:firefly/domain/entities/search_result.dart';
import 'package:firefly/domain/entities/track.dart';
import 'package:firefly/data/datasources/remote/spotify_api.dart';
import 'package:firefly/data/datasources/remote/youtube_music_api.dart';
import 'package:firefly/data/repositories/search_repository_impl.dart';
import 'package:firefly/presentation/widgets/cards/album_card.dart';
import 'package:firefly/presentation/widgets/cards/artist_card.dart';
import 'package:firefly/presentation/widgets/cards/track_card.dart';
import 'package:firefly/presentation/widgets/cards/playlist_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {
  late final SearchBloc _searchBloc;
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _currentQuery = '';

  final List<Tab> _tabs = const [
    Tab(text: 'Tracks'),
    Tab(text: 'Albums'),
    Tab(text: 'Artists'),
    Tab(text: 'Playlists'),
    Tab(text: 'Trending'),
  ];

  @override
  void initState() {
    super.initState();
    _searchBloc = SearchBloc(repository: SearchRepositoryImpl(
      spotifyApi: SpotifyApi(),
      youtubeMusicApi: YouTubeMusicApi(),
    ));
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _searchBloc.close();
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_currentQuery.isNotEmpty && _tabController.index < 4) {
      _performSearch(_currentQuery);
    }
  }

  void _performSearch(String query) {
    setState(() {
      _currentQuery = query;
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
      case 4:
        _searchBloc.add(GetTrendingEvent());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: _buildSearchBar(),
         bottom: _buildTabBar() as PreferredSizeWidget?,
      ),
      body: BlocProvider.value(
        value: _searchBloc,
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            return _buildBody(state);
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
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
                hintText: 'Search tracks, albums...',
                hintStyle: TextStyle(color: Color(0xFF666666)),
                border: InputBorder.none,
                isDense: true,
              ),
              onSubmitted: _performSearch,
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Color(0xFFB3B3B3), size: 20),
              onPressed: () {
                _searchController.clear();
                _searchBloc.add(ClearSearchEvent());
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: TabBar(
        controller: _tabController,
        tabs: _tabs,
        indicatorColor: const Color(0xFFFFB300),
        indicatorWeight: 3,
        labelColor: const Color(0xFFFFB300),
        unselectedLabelColor: const Color(0xFFB3B3B3),
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
        ),
        isScrollable: true,
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget _buildBody(SearchState state) {
    if (state is SearchInitial) {
      return const Center(
        child: Text(
          'Search for music, artists, and more',
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 16,
          ),
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
              style: TextStyle(
                color: Color(0xFFB3B3B3),
              ),
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
              Icon(
                Icons.music_note, size: 64,
                color: Color(0xFF666666),
              ),
              const SizedBox(height: 16),
              Text(
                'No results found for "${state.query}"',
                style: const TextStyle(
                  color: Color(0xFFB3B3B3),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: state.results.length,
        itemBuilder: (context, index) {
          final result = state.results[index];
          return _buildResultItem(result, state.type);
        },
      );
    } else if (state is RecommendationsLoaded) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: state.results.length,
        itemBuilder: (context, index) {
          final result = state.results[index];
          return _buildResultItem(result, 'tracks');
        },
      );
    } else if (state is TrendingLoaded) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: state.results.length,
        itemBuilder: (context, index) {
          final result = state.results[index];
          return _buildResultItem(result, 'tracks');
        },
      );
    } else if (state is SearchError) {
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
              'Search failed',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.error,
              style: const TextStyle(
                color: Color(0xFFB3B3B3),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildResultItem(SearchResult result, String type) {
    switch (type) {
      case 'tracks':
         return TrackCard(
            track: Track(
              id: result.id,
              title: result.title,
              artist: result.artist,
              album: result.album ?? '',
              filePath: '',
              duration: result.duration ?? Duration.zero,
              fileSize: 0,
              createdAt: DateTime.now(),
              genre: '',
              bitrate: 128,
              sampleRate: 44100,
              channels: 2,
            ),
            onTap: () {
            // Handle track tap
          },
        );
       case 'albums':
          return AlbumCard(
            title: result.title,
            artist: result.artist,
            onTap: () {
            // Handle album tap
          },
        );
       case 'artists':
          return ArtistCard(
            name: result.title,
            genre: 'Unknown',
            onTap: () {
            // Handle artist tap
          },
        );
       case 'playlists':
          return PlaylistCard(
            title: result.title,
            trackCount: result.trackCount ?? 0,
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
}
