import 'package:flutter/material.dart';
import 'package:firefly/constants/route_constants.dart';
import 'package:firefly/presentation/pages/main/main_page.dart';
import 'package:firefly/presentation/pages/local/local_music_page.dart';
import 'package:firefly/presentation/pages/player/now_playing_page.dart';
import 'package:firefly/presentation/pages/local/directory_selection_page.dart';
import 'package:firefly/presentation/pages/search/search_page.dart';

class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.main:
        return MaterialPageRoute(builder: (_) => const MainPage());
      case RouteConstants.local:
        return MaterialPageRoute(builder: (_) => const LocalMusicPage());
      case RouteConstants.player:
        return MaterialPageRoute(builder: (_) => const NowPlayingPage());
      case RouteConstants.directorySelection:
        return MaterialPageRoute(builder: (_) => const DirectorySelectionPage());
      case RouteConstants.search:
        return MaterialPageRoute(builder: (_) => const SearchPage());
      default:
         return MaterialPageRoute(
           builder: (_) => Scaffold(
             body: Center(
               child: Text('Route not found: ${settings.name}'),
             ),
           ),
         );
    }
  }
}
