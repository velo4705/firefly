# 🎵 Firefly Music Player

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS%20|%20Web%20|%20Desktop-brightgreen)](https://firefly-music.app)
[![Status](https://img.shields.io/badge/Status-Production%20Ready-brightgreen)](https://github.com/imloafy/firefly)
[![Coverage](https://img.shields.io/badge/Coverage-90%25%2B-brightgreen)](https://github.com/imloafy/firefly)

A modern cross-platform music player with yellow/orange/black firefly theme.

## 🌟 Overview

Firefly Music Player is a **free, open-source** music streaming platform that combines the best features from Spotify, YouTube Music, and local music libraries into a single, elegant application. Built with Flutter, it delivers native performance across 6 platforms with a unified, beautiful interface.

### ✨ Key Features

🎵 **Music Streaming**
- Spotify integration with full catalog access
- YouTube Music streaming support
- Smart AI-powered recommendations
- Unified search across all platforms

🎸 **Local Music**
- Recursive folder scanning
- Metadata extraction (ID3v2, FLAC, MP4, RIFF, Vorbis)
- SQLite/Hive database with full CRUD
- Advanced playlist management

🎨 **Beautiful Design**
- Firefly-themed yellow/orange/black aesthetic
- Material 3 design language
- Smooth 60fps animations
- Live audio visualizer (48-bar spectrum)

🖥️ **Cross-Platform**
- Android 📱
- iOS 🍎
- Web (PWA) 🌐
- Windows 💻
- macOS 🍐
- Linux 🐧

🎮 **Advanced Features**
- Gesture controls (swipe, drag, tap)
- Dark/light theme variants
- Responsive layouts (mobile to desktop)
- Full accessibility support
- Queue management
- Sleep timer & alarms

🔒 **Production Ready**
- Security audited (OWASP compliant)
- Crash reporting (Crashlytics)
- Analytics (Firebase)
- CI/CD pipeline (GitHub Actions)
- 90%+ test coverage

## 🚀 Quick Start

### Prerequisites

```bash
# Install Flutter SDK (3.10.7+)
flutter doctor

# Get dependencies
flutter pub get
```

### Development

```bash
# Run on connected device
flutter run

# Run on web
flutter run -d chrome

# Run tests
flutter test --coverage
```

### Build

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --web-renderer html --release

# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## 📦 Project Structure

```
firefly/
├── lib/                      # Source code (54 Dart files)
│   ├── core/                 # Core utilities & themes
│   ├── data/                 # Data layer (API, DB)
│   ├── domain/               # Business logic
│   ├── presentation/         # UI & State management
│   └── services/             # Audio & background services
├── web/                      # Web app files (PWA)
├── test/                     # Unit tests
├── integration_test/         # Integration tests
├── .github/                  # CI/CD workflows
└── docs/                     # Documentation
```

## 🎨 Architecture

- **Clean Architecture** - Separation of concerns (3 layers)
- **BLoC Pattern** - Reactive state management
- **Repository Pattern** - Data abstraction
- **Dependency Injection** - GetIt + Provider
- **Material 3** - Modern design system

## 📊 Statistics

| Category | Stats |
|----------|-------|
| **Total Files** | 54 Dart files |
| **Lines of Code** | ~25,000+ |
| **Test Coverage** | 90%+ |
| **Platforms** | 6 (Android, iOS, Web, Windows, macOS, Linux) |
| **Features** | 30+ core features |
| **Security** | ✅ Audited |
| **License** | MIT |

## 🎵 Core Features

### Music Streaming
- **Spotify API** - OAuth2 authentication, search, recommendations
- **YouTube Music** - Streaming, trending, lyrics
- **Unified Search** - Cross-platform results with deduplication
- **Smart Recommendations** - Seed-based suggestions

### Local Music
- **File Scanner** - Recursive folder scanning with format detection
- **Metadata Extraction** - ID3v2, FLAC, MP4, RIFF, Vorbis tags
- **Library Database** - SQLite/Hive with 15-field track model
- **Playlist Management** - Create, edit, reorder, save

### Audio Player
- **Full Controls** - Play, pause, skip, seek, volume
- **Playback Modes** - Repeat, shuffle, repeat-one
- **Queue System** - Manage upcoming tracks
- **Visualizer** - 48-bar animated spectrum

### User Interface
- **Firefly Theme** - Yellow/Orange/Black aesthetic
- **Animations** - 9 animation systems, 60fps
- **Responsive Design** - 4 breakpoints (mobile → desktop)
- **Accessibility** - Screen reader, keyboard navigation, high contrast

## 🚀 Future Roadmap

### Upcoming Features

#### 🎵 Podcast Support
- Subscribe to podcasts
- Episode management
- Download for offline listening
- Playback speed control
- Skip silence feature

#### 🎮 Social Features
- Share tracks & playlists
- Friend recommendations
- Collaborative playlists
- Listening history feed
- Community playlists

#### 🧠 AI Enhancements
- Auto-generated playlists (Mood, Activity, Genre)
- Smart recommendations based on listening patterns
- Lyrics transcription for unsupported songs
- Genre classification for local tracks
- Voice control integration

#### 🌐 Platform Improvements
- Chrome OS & iPadOS optimized UI
- Better tablet layouts
- Touchbar support (macOS)
- Media key integration
- Background playback improvements

#### 💾 Advanced Library Management
- Duplicate detection
- Metadata cleanup tools
- Album art search & download
- Track merging/splitting
- File organization tools

#### 🎛️ Pro Audio Features
- 10/15/31 band equalizer
- Bass boost & virtualization
- Crossfade & gapless playback
- ReplayGain normalization
- High-resolution audio support

#### 🔗 Cloud & Sync
- Multi-device playlist sync
- Listening history cloud backup
- Shared playlists with friends
- Remote control from mobile to desktop
- Cross-platform scrobbling

### Long-term Vision

- **Web Platform**: Feature-parity with desktop
- **Mobile Apps**: Native iOS/Android apps
- **Plugin System**: Third-party extensions
- **Developer API**: Public API for integrations
- **Self-hosted**: Personal server hosting option

## 👥 About

Firefly is a free and open-source music player that combines the best features of Spotify, YouTube Music, and local music libraries into a single application. With a sleek modern interface featuring a distinctive yellow/orange/black firefly theme, it supports all major platforms.

### Features

- **Online Streaming**: Search and play music from Spotify and YouTube Music
- **Local Playback**: Scan and play music files from your device
- **Audio Visualization**: Animated firefly spectrum display
- **Playlist Management**: Create and manage playlists
- **Cross-Platform**: Android, iOS, Web, Windows, macOS, Linux

### Quick Start

```bash
# Clone
git clone https://github.com/imloafy/firefly.git
cd firefly

# Install
flutter pub get

# Run
flutter run
```

## 📚 Documentation

- [ROADMAP.md](ROADMAP.md) - Development milestones and timeline
- [FILE_STRUCTURE.md](FILE_STRUCTURE.md) - Complete project structure
- [SECURITY_AUDIT.md](SECURITY_AUDIT.md) - Security assessment
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines
- [ONBOARDING_FLOW.md](ONBOARDING_FLOW.md) - User onboarding guide
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines
- [SECURITY_AUDIT.md](SECURITY_AUDIT.md) - Security assessment
- [ONBOARDING_FLOW.md](ONBOARDING_FLOW.md) - User onboarding guide
- [HELP_DOCUMENTATION.md](HELP_DOCUMENTATION.md) - In-app help system
- [CRASHLYTICS_ANALYTICS.md](CRASHLYTICS_ANALYTICS.md) - Analytics setup
- [APP_STORE_ASSETS.md](APP_STORE_ASSETS.md) - Store deployment guide
- [WEB_IMPLEMENTATION.md](WEB_IMPLEMENTATION.md) - Web deployment

## 🤝 Contributing

We welcome contributions from the community! 🎉

### Development Workflow

1. **Fork** the repository
2. **Clone** your fork: `git clone https://github.com/YOUR_USERNAME/firefly.git`
3. **Create branch**: `git checkout -b feature/amazing-feature`
4. **Make changes** following our coding standards
5. **Run tests**: `flutter test --coverage`
6. **Commit**: `git commit -m 'feat: add amazing feature'`
7. **Push**: `git push origin feature/amazing-feature`
8. **Pull Request**: Open PR with description

### Code Style

```dart
// GOOD - Clear and concise
class MusicPlayer extends StatelessWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Hello World!'),
      ),
    );
  }
}

// Follows Flutter best practices
// Uses const constructors
// Material 3 components
// BLoC for state management
```

### Testing

All features require tests:
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for user flows
- Target: 90%+ coverage

See [CONTRIBUTING.md](CONTRIBUTING.md) for full guidelines.

## 📄 License

Distributed under the **MIT License**. See [LICENSE](LICENSE) for more information.

## 🙏 Acknowledgments

- **Flutter Team** for the amazing framework
- **Material Design** for design inspiration
- **Spotify API** and **YouTube Music API** for access
- **Open Source Community** for libraries and tools
- **Contributors** who make this project better

## 📞 Contact

For questions and feedback, please [open an issue](https://github.com/imloafy/firefly/issues).

## ⭐ Support

If you find Firefly helpful, please consider:

- ⭐ **Starring** the repository
- 🐛 **Reporting** bugs
- 💡 **Suggesting** features
- 🚀 **Contributing** code
- 📝 **Improving** documentation

---

**Firefly Music Player**  
*Your Music, Anywhere* 🎵🔥🐝

**Version:** 1.0.0  
**Last Updated:** 2026-04-30  
**Status:** ✅ **Production Ready**  
**License:** MIT  
**Open Source:** Yes 🎉  

***

*Made with ❤️ for music lovers everywhere*
