# Firefly Music Player - File Structure

## 📁 Complete Flutter Project Structure

```
firefly/
├── README.md
├── ROADMAP.md
├── pubspec.yaml
├── analysis_options.yaml
├── .gitignore
├── .metadata
├── android/
│   ├── app/
│   │   ├── build.gradle
│   │   ├── src/main/kotlin/com/example/firefly/MainActivity.kt
│   │   └── src/main/AndroidManifest.xml
│   ├── build.gradle
│   ├── gradle.properties
│   └── settings.gradle
├── ios/
│   ├── Runner/
│   │   ├── AppDelegate.swift
│   │   ├── Info.plist
│   │   └── Runner-Bridging-Header.h
│   └── Runner.xcodeproj/
├── macos/
│   ├── Runner/
│   │   ├── AppDelegate.swift
│   │   ├── Info.plist
│   │   └── MainFlutterWindow.swift
│   └── Runner.xcodeproj/
├── linux/
│   ├── CMakeLists.txt
│   ├── my_application.cc
│   └── runner.h
├── windows/
│   ├── CMakeLists.txt
│   ├── runner/
│   │   ├── CMakeLists.txt
│   │   ├── main.cpp
│   │   ├── resource.h
│   │   ├── runner.exe.manifest
│   │   ├── win32_window.cpp
│   │   ├── win32_window.h
│   │   ├── flutter_window.cpp
│   │   └── flutter_window.h
│   └── flutter_window.cpp
├── web/
│   ├── index.html
│   ├── manifest.json
│   └── flutter_service_worker.js
├── test/
│   ├── unit/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   └── services/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── usecases/
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   ├── widget/
│   │   ├── components/
│   │   └── pages/
│   └── integration/
│       ├── app_test.dart
│       ├── player_test.dart
│       └── api_test.dart
├── integration_test/
│   ├── app_test.dart
│   ├── player_flow_test.dart
│   └── login_flow_test.dart
└── lib/
    ├── main.dart
    ├── app.dart
    ├── constants/
    │   ├── app_constants.dart
    │   ├── color_constants.dart
    │   ├── route_constants.dart
    │   ├── api_constants.dart
    │   └── theme_constants.dart
    ├── core/
    │   ├── utils/
    │   │   ├── logger.dart
    │   │   ├── file_utils.dart
    │   │   ├── network_utils.dart
    │   │   ├── permission_utils.dart
    │   │   ├── format_utils.dart
    │   │   └── cache_utils.dart
    │   ├── errors/
    │   │   ├── exceptions.dart
    │   │   ├── failures.dart
    │   │   └── error_handler.dart
    │   ├── network/
    │   │   ├── dio_client.dart
    │   │   ├── api_interceptor.dart
    │   │   └── network_info.dart
    │   ├── storage/
    │   │   ├── local_storage.dart
    │   │   ├── secure_storage.dart
    │   │   └── cache_storage.dart
    │   └── themes/
    │       ├── app_theme.dart
    │       ├── dark_theme.dart
    │       ├── light_theme.dart
    │       └── theme_extensions.dart
    ├── data/
    │   ├── models/
    │   │   ├── track_model.dart
    │   │   ├── album_model.dart
    │   │   ├── artist_model.dart
    │   │   ├── playlist_model.dart
    │   │   ├── user_model.dart
    │   │   ├── search_result_model.dart
    │   │   └── local_file_model.dart
    │   ├── datasources/
    │   │   ├── local/
    │   │   │   ├── music_database.dart
    │   │   │   ├── playlist_dao.dart
    │   │   │   ├── track_dao.dart
    │   │   │   └── app_preferences.dart
    │   │   ├── remote/
    │   │   │   ├── spotify_api.dart
    │   │   │   ├── youtube_music_api.dart
    │   │   │   ├── auth_service.dart
    │   │   │   └── search_api.dart
    │   │   └── file/
    │   │       ├── local_file_reader.dart
    │   │       ├── metadata_extractor.dart
    │   │       └── directory_scanner.dart
    │   └── repositories/
    │       ├── music_repository_impl.dart
    │       ├── auth_repository_impl.dart
    │       ├── playlist_repository_impl.dart
    │       ├── search_repository_impl.dart
    │       └── local_repository_impl.dart
    ├── domain/
    │   ├── entities/
    │   │   ├── track.dart
    │   │   ├── album.dart
    │   │   ├── artist.dart
    │   │   ├── playlist.dart
    │   │   ├── user.dart
    │   │   ├── search_result.dart
    │   │   └── player_state.dart
    │   ├── repositories/
    │   │   ├── music_repository.dart
    │   │   ├── auth_repository.dart
    │   │   ├── playlist_repository.dart
    │   │   ├── search_repository.dart
    │   │   └── local_repository.dart
    │   └── usecases/
    │       ├── music/
    │       │   ├── get_tracks_usecase.dart
    │       │   ├── get_track_details_usecase.dart
    │       │   ├── play_track_usecase.dart
    │       │   └── get_recommendations_usecase.dart
    │       ├── auth/
    │       │   ├── login_usecase.dart
    │       │   ├── logout_usecase.dart
    │       │   └── get_user_profile_usecase.dart
    │       ├── playlist/
    │       │   ├── create_playlist_usecase.dart
    │       │   ├── add_to_playlist_usecase.dart
    │       │   └── get_playlists_usecase.dart
    │       ├── search/
    │       │   ├── search_tracks_usecase.dart
    │       │   ├── search_artists_usecase.dart
    │       │   └── search_albums_usecase.dart
    │       └── local/
    │           ├── scan_local_music_usecase.dart
    │           ├── get_local_tracks_usecase.dart
    │           └── set_music_directory_usecase.dart
    ├── presentation/
    │   ├── providers/
    │   │   ├── audio_player_provider.dart
    │   │   ├── theme_provider.dart
    │   │   ├── auth_provider.dart
    │   │   └── local_music_provider.dart
    │   ├── bloc/
    │   │   ├── player/
    │   │   │   ├── player_bloc.dart
    │   │   │   ├── player_event.dart
    │   │   │   └── player_state.dart
    │   │   ├── music/
    │   │   │   ├── music_bloc.dart
    │   │   │   ├── music_event.dart
    │   │   │   └── music_state.dart
    │   │   ├── auth/
    │   │   │   ├── auth_bloc.dart
    │   │   │   ├── auth_event.dart
    │   │   │   └── auth_state.dart
    │   │   ├── search/
    │   │   │   ├── search_bloc.dart
    │   │   │   ├── search_event.dart
    │   │   │   └── search_state.dart
    │   │   ├── playlist/
    │   │   │   ├── playlist_bloc.dart
    │   │   │   ├── playlist_event.dart
    │   │   │   └── playlist_state.dart
    │   │   └── local/
    │   │       ├── local_music_bloc.dart
    │   │       ├── local_music_event.dart
    │   │       └── local_music_state.dart
    │   ├── pages/
    │   │   ├── main/
    │   │   │   ├── main_page.dart
    │   │   │   └── widgets/
    │   │   │       ├── custom_bottom_nav.dart
    │   │   │       └── app_drawer.dart
    │   │   ├── online/
    │   │   │   ├── online_music_page.dart
    │   │   │   ├── album_detail_page.dart
    │   │   │   ├── artist_detail_page.dart
    │   │   │   └── widgets/
    │   │   │       ├── track_card.dart
    │   │   │       ├── album_card.dart
    │   │   │       ├── artist_card.dart
    │   │   │       └── search_bar.dart
    │   │   ├── local/
    │   │   │   ├── local_music_page.dart
    │   │   │   ├── directory_selection_page.dart
    │   │   │   └── widgets/
    │   │   │       ├── local_track_card.dart
    │   │   │       ├── folder_browser.dart
    │   │   │       └── scanning_indicator.dart
    │   │   ├── player/
    │   │   │   ├── now_playing_page.dart
    │   │   │   ├── queue_page.dart
    │   │   │   └── widgets/
    │   │   │       ├── player_controls.dart
    │   │   │       ├── track_progress.dart
    │   │   │       ├── volume_slider.dart
    │   │   │       ├── playlist_queue.dart
    │   │   │       └── audio_visualizer.dart
    │   │   ├── library/
    │   │   │   ├── library_page.dart
    │   │   │   ├── playlists_page.dart
    │   │   │   ├── favorites_page.dart
    │   │   │   ├── history_page.dart
    │   │   │   └── widgets/
    │   │   │       ├── playlist_tile.dart
    │   │   │       ├── favorite_track_tile.dart
    │   │   │       └── history_item_tile.dart
    │   │   ├── search/
    │   │   │   ├── search_page.dart
    │   │   │   └── widgets/
    │   │   │       ├── search_results.dart
    │   │   │       ├── search_filters.dart
    │   │   │       └── recent_searches.dart
    │   │   ├── settings/
    │   │   │   ├── settings_page.dart
    │   │   │   ├── audio_settings_page.dart
    │   │   │   ├── theme_settings_page.dart
    │   │   │   ├── account_settings_page.dart
    │   │   │   └── widgets/
    │   │   │       ├── settings_tile.dart
    │   │   │       ├── theme_selector.dart
    │   │   │       └── account_info.dart
    │   │   └── auth/
    │   │       ├── login_page.dart
    │   │       ├── spotify_auth_page.dart
    │   │       ├── youtube_auth_page.dart
    │   │       └── widgets/
    │   │           ├── auth_button.dart
    │   │           └── service_selector.dart
    │   ├── widgets/
    │   │   ├── common/
    │   │   │   ├── custom_app_bar.dart
    │   │   │   ├── loading_indicator.dart
    │   │   │   ├── error_widget.dart
    │   │   │   ├── empty_state.dart
    │   │   │   ├── custom_button.dart
    │   │   │   ├── custom_text_field.dart
    │   │   │   └── shimmer_loading.dart
    │   │   ├── cards/
    │   │   │   ├── base_card.dart
    │   │   │   ├── track_card.dart
    │   │   │   ├── album_card.dart
    │   │   │   └── artist_card.dart
    │   │   ├── player/
    │   │   │   ├── mini_player.dart
    │   │   │   ├── player_controls.dart
    │   │   │   ├── track_info.dart
    │   │   │   └── play_pause_button.dart
    │   │   └── animations/
    │   │       ├── firefly_animation.dart
    │   │       ├── fade_animation.dart
    │   │       ├── slide_animation.dart
    │   │       └── scale_animation.dart
    │   └── router/
    │       ├── app_router.dart
    │       ├── route_generator.dart
    │       └── page_transitions.dart
    └── services/
        ├── audio/
        │   ├── audio_player_service.dart
        │   ├── audio_manager.dart
        │   ├── playback_handler.dart
        │   └── audio_session_manager.dart
        ├── notification/
        │   ├── notification_service.dart
        │   ├── player_notification.dart
        │   └── system_tray_service.dart
        ├── background/
        │   ├── background_play_service.dart
        │   ├── background_task.dart
        │   └── app_lifecycle_manager.dart
        └── sync/
            ├── cloud_sync_service.dart
            ├── playlist_sync.dart
            └── preference_sync.dart
```

---

## 📋 Key Files Description

### **Root Configuration**
- `pubspec.yaml` - Dependencies and project metadata
- `analysis_options.yaml` - Code analysis and linting rules
- `README.md` - Project documentation
- `ROADMAP.md` - Development milestones

### **Core Architecture**
- `lib/core/` - Shared utilities, themes, error handling
- `lib/data/` - Data layer (models, datasources, repository implementations)
- `lib/domain/` - Business logic (entities, repositories, use cases)
- `lib/presentation/` - UI layer (pages, widgets, BLoC state management)

### **Key Components**
- **Audio Player**: `lib/services/audio/` - Complete audio playback system
- **API Integration**: `lib/data/datasources/remote/` - Spotify & YouTube Music APIs
- **Local Music**: `lib/data/datasources/file/` - File scanning and metadata
- **Theme System**: `lib/core/themes/` - Firefly theming
- **State Management**: `lib/presentation/bloc/` - BLoC pattern implementation

### **Platform Support**
- `android/`, `ios/`, `macos/`, `linux/`, `windows/`, `web/` - Platform-specific code
- `integration_test/` - End-to-end testing
- `test/` - Unit and widget testing

---

## 🎯 Architecture Principles

1. **Clean Architecture** - Separation of concerns with distinct layers
2. **BLoC Pattern** - Reactive state management
3. **Dependency Injection** - Testable and maintainable code
4. **Modular Design** - Feature-based organization
5. **Cross-Platform** - Single codebase for all platforms

---

## 📦 Required Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.3
  provider: ^6.0.5
  
  # Audio & Media
  just_audio: ^0.9.36
  audio_session: ^0.1.16
  
  # Network & APIs
  dio: ^5.3.2
  spotify_sdk: ^2.3.0
  youtube_explode_dart: ^2.2.1
  
  # Local Storage
  sqflite: ^2.3.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.2
  path_provider: ^2.1.1
  
  # File System
  path: ^1.8.3
  file_picker: ^6.1.1
  
  # UI & Animations
  cupertino_icons: ^1.0.2
  lottie: ^2.7.0
  shimmer: ^3.0.0
  
  # Utils
  permission_handler: ^11.0.1
  url_launcher: ^6.2.1
  package_info_plus: ^4.2.0
  
  # Notifications
  flutter_local_notifications: ^16.3.0
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  mockito: ^5.4.2
  build_runner: ^2.4.7
  hive_generator: ^2.0.1
  integration_test:
    sdk: flutter
```

This structure provides a solid foundation for building your Firefly music player with scalability, maintainability, and cross-platform compatibility.