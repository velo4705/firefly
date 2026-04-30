import 'package:flutter/material.dart';
import 'package:firefly/presentation/pages/local/local_music_page.dart';
import 'package:firefly/presentation/pages/online/online_music_page.dart';
import 'package:firefly/presentation/pages/search/search_page.dart';
import 'package:firefly/presentation/widgets/common/responsive_layout.dart';
import 'package:firefly/presentation/widgets/common/accessibility.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'page': const OnlineMusicPage(),
      'title': 'Online',
    },
    {
      'page': const LocalMusicPage(),
      'title': 'Local',
    },
    {
      'page': const SearchPage(),
      'title': 'Library',
    },
    {
      'page': const Placeholder(color: Color(0xFF121212), child: Center(child: Text('Settings'))),
      'title': 'Settings',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (_currentIndex != 0) {
            setState(() {
              _currentIndex = 0;
            });
          } else {
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFF121212),
          body: Semantics(
            label: 'Firefly Music Player - ${_pages[_currentIndex]['title']}',
            child: ResponsiveBuilder(
              mobile: _buildMobileBody(),
              tablet: _buildTabletBody(),
            ),
          ),
          bottomNavigationBar: _buildBottomNavigationBar(),
        ),
      ),
    );
  }

  Widget _buildMobileBody() {
    return IndexedStack(
      index: _currentIndex,
      children: _pages.map((page) => page['page'] as Widget).toList(),
    );
  }

  Widget _buildTabletBody() {
    if (_currentIndex == 2) {
      // Library view on tablet: split view
      return Row(
        children: [
          // Sidebar
          Container(
            width: 300,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              border: Border(
                right: BorderSide(color: const Color(0xFF2A2A2A), width: 1),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Library',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
                const Divider(height: 1, color: Color(0xFF2A2A2A)),
                const Spacer(),
              ],
            ),
          ),
          // Main content
          Expanded(child: _pages[2]['page'] as Widget),
        ],
      );
    }
    return _buildMobileBody();
  }

  Widget _buildBottomNavigationBar() {
    return Semantics(
      label: 'Navigation bar',
      child: ResponsiveBuilder(
        mobile: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF0D0D0D),
          selectedItemColor: const Color(0xFFFFB300),
          unselectedItemColor: const Color(0xFF666666),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              label: 'Online',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder),
              label: 'Local',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
        tablet: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF0D0D0D),
          selectedItemColor: const Color(0xFFFFB300),
          unselectedItemColor: const Color(0xFF666666),
          selectedFontSize: 14,
          unselectedFontSize: 14,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note, size: 28),
              label: 'Online',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder, size: 28),
              label: 'Local',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music, size: 28),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, size: 28),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}