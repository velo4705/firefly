# User Onboarding Flow

## Onboarding Screens

### Screen 1: Welcome
```dart
// lib/presentation/pages/onboarding/welcome_page.dart
class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF121212),
              Color(0xFF1E1E1E),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Firefly Logo
              _buildFireflyLogo(),
              SizedBox(height: 48),
              Text(
                'Firefly Music Player',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Your Music, Anywhere',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFB3B3B3),
                ),
              ),
              SizedBox(height: 64),
              _buildGetStartedButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Screen 2: Choose Your Path
```dart
// lib/presentation/pages/onboarding/path_choice_page.dart
class PathChoicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'How do you want to listen?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 48),
            _buildPathCard(
              context,
              icon: Icons.wifi,
              title: 'Stream Online',
              subtitle: 'Access Spotify and YouTube Music',
              color: Color(0xFFFFB300),
              onTap: () => _selectPath(context, 'online'),
            ),
            SizedBox(height: 24),
            _buildPathCard(
              context,
              icon: Icons.folder_music,
              title: 'Listen Local',
              subtitle: 'Play music from your device',
              color: Color(0xFF4CAF50),
              onTap: () => _selectPath(context, 'local'),
            ),
            SizedBox(height: 24),
            _buildPathCard(
              context,
              icon: Icons.sync,
              title: 'Both',
              subtitle: 'Combine online and local music',
              color: Color(0xFF2196F3),
              onTap: () => _selectPath(context, 'both'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Screen 3: Connect Services
```dart
// lib/presentation/pages/onboarding/service_connection_page.dart
class ServiceConnectionPage extends StatefulWidget {
  final String selectedPath;
  
  ServiceConnectionPage({required this.selectedPath});
  
  @override
  _ServiceConnectionPageState createState() => _ServiceConnectionPageState();
}

class _ServiceConnectionPageState extends State<ServiceConnectionPage> {
  bool _spotifyConnected = false;
  bool _youtubeConnected = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Connect Your Services',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Connect the music services you want to use',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFB3B3B3),
              ),
            ),
            SizedBox(height: 48),
            if (widget.selectedPath == 'online' || widget.selectedPath == 'both')
              _buildServiceCard(
                context,
                icon: Icons.music_note,
                title: 'Spotify',
                subtitle: 'Access your Spotify library',
                connected: _spotifyConnected,
                onConnect: _connectSpotify,
              ),
            if (widget.selectedPath == 'online' || widget.selectedPath == 'both')
              SizedBox(height: 24),
            if (widget.selectedPath == 'online' || widget.selectedPath == 'both')
              _buildServiceCard(
                context,
                icon: Icons.play_circle,
                title: 'YouTube Music',
                subtitle: 'Stream music from YouTube',
                connected: _youtubeConnected,
                onConnect: _connectYouTube,
              ),
            SizedBox(height: 48),
            _buildContinueButton(context),
          ],
        ),
      ),
    );
  }
}
```

### Screen 4: Set Preferences
```dart
// lib/presentation/pages/onboarding/preferences_page.dart
class PreferencesPage extends StatefulWidget {
  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  bool _darkMode = true;
  bool _autoPlay = true;
  bool _downloadOverWifi = true;
  String _audioQuality = 'high';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Customize Your Experience',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  _buildPreferenceSwitch(
                    title: 'Dark Mode',
                    subtitle: 'Use dark theme',
                    value: _darkMode,
                    onChanged: (value) => setState(() => _darkMode = value),
                  ),
                  _buildPreferenceSwitch(
                    title: 'Auto-Play',
                    subtitle: 'Automatically play next track',
                    value: _autoPlay,
                    onChanged: (value) => setState(() => _autoPlay = value),
                  ),
                  _buildPreferenceSwitch(
                    title: 'Download on Wi-Fi Only',
                    subtitle: 'Prevent mobile data usage',
                    value: _downloadOverWifi,
                    onChanged: (value) => setState(() => _downloadOverWifi = value),
                  ),
                  _buildQualityDropdown(),
                ],
              ),
            ),
            _buildCompleteButton(context),
          ],
        ),
      ),
    );
  }
}
```

### Screen 5: Ready to Go
```dart
// lib/presentation/pages/onboarding/completion_page.dart
class CompletionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 120,
              color: Color(0xFFFFB300),
            ),
            SizedBox(height: 32),
            Text(
              'All Set!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Firefly is ready to play your music',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFB3B3B3),
              ),
            ),
            SizedBox(height: 48),
            _buildStartButton(context),
          ],
        ),
      ),
    );
  }
}
```

## Onboarding Manager

```dart
// lib/core/onboarding/onboarding_manager.dart
class OnboardingManager {
  static const String _onboardingCompleteKey = 'onboarding_complete';
  static const String _preferredPathKey = 'preferred_path';
  static const String _servicesConnectedKey = 'services_connected';

  static Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  static Future<void> setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);
  }

  static Future<void> setPreferredPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_preferredPathKey, path);
  }

  static Future<String?> getPreferredPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_preferredPathKey);
  }

  static Future<void> completeOnboarding(BuildContext context) async {
    await setOnboardingComplete();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }
}
```

## Onboarding Wrapper

```dart
// lib/main.dart (updated)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firefly',
      theme: AppTheme.darkTheme,
      home: FutureBuilder<bool>(
        future: OnboardingManager.isOnboardingComplete(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }
          
          if (snapshot.data == true) {
            return MainPage();
          } else {
            return OnboardingFlow();
          }
        },
      ),
    );
  }
}

// lib/presentation/pages/onboarding/onboarding_flow.dart
class OnboardingFlow extends StatefulWidget {
  @override
  _OnboardingFlowState createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    WelcomePage(),
    PathChoicePage(),
    ServiceConnectionPage(selectedPath: 'both'),
    PreferencesPage(),
    CompletionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
        children: _pages,
      ),
    );
  }
}
```

## Skip Onboarding Option

```dart
// Allow users to skip onboarding
TextButton(
  onPressed: () => OnboardingManager.completeOnboarding(context),
  child: Text('Skip'),
)
```

## Re-onboarding

```dart
// lib/presentation/pages/settings/settings_page.dart
ListTile(
  title: Text('Retake Onboarding'),
  subtitle: Text('Reset preferences and guides'),
  trailing: Icon(Icons.chevron_right),
  onTap: () async {
    await OnboardingManager.setPreferredPath(null);
    // Reset other preferences
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OnboardingFlow()),
    );
  },
)
```

## Best Practices

1. **Keep it brief** - 3-5 screens maximum
2. **Show value** - Demonstrate key features
3. **Minimal inputs** - Don't overwhelm users
4. **Clear CTAs** - Obvious next steps
5. **Skip option** - Allow quick access
6. **Save progress** - Resume if interrupted
7. **Test thoroughly** - Different device sizes
8. **Analytics** - Track completion rates
