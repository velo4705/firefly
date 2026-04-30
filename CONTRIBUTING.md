# Contributing to Firefly

We welcome contributions from the community! This document outlines how to contribute to the Firefly Music Player project.

## 🚀 Getting Started

### Prerequisites

- Git
- Flutter SDK 3.10.7+
- Dart 3.10.7+
- IDE (VS Code or Android Studio recommended)

### Setup

1. Fork the repository
2. Clone your fork:
```bash
git clone https://github.com/YOUR_USERNAME/firefly.git
cd firefly
```

3. Install dependencies:
```bash
flutter pub get
```

4. Verify setup:
```bash
flutter doctor
flutter test
```

## 📋 Development Workflow

### 1. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
```

Use descriptive branch names:
- `feature/spotify-integration`
- `bugfix/audio-player-crash`
- `enhancement/ui-polish`

### 2. Make Your Changes

Follow our coding standards:

#### Code Style

```dart
// GOOD - Clear and concise
class MusicPlayer extends StatelessWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Playing...'),
      ),
    );
  }
}

// BAD - Avoid
class MusicPlayer extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Playing...')));
  }
}
```

#### State Management

Use BLoC for complex state:

```dart
// events.dart
abstract class MusicEvent {}
class PlayMusic extends MusicEvent {}
class PauseMusic extends MusicEvent {}

// bloc.dart
class MusicBloc extends Bloc<MusicEvent, MusicState> {
  MusicBloc() : super(MusicInitial()) {
    on<PlayMusic>((event, emit) {
      emit(MusicPlaying());
    });
  }
}
```

#### Testing

All new features must include tests:

```dart
test('MusicBloc plays music', () {
  final bloc = MusicBloc();
  bloc.add(PlayMusic());
  expectLater(bloc.stream, emits(MusicPlaying()));
});
```

### 3. Run Tests

```bash
# Unit tests
flutter test

# Widget tests
flutter test test/widget_test.dart

# Integration tests
flutter drive --target=integration_test/app_test.dart

# Coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### 4. Format Code

```bash
flutter format .
```

### 5. Analyze Code

```bash
flutter analyze
```

### 6. Commit Your Changes

```bash
git add .
git commit -m "feat: add Spotify integration"
```

Use conventional commits:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation
- `style:` Code style
- `refactor:` Code refactoring
- `test:` Tests
- `chore:` Maintenance

### 7. Push to Your Fork

```bash
git push origin feature/your-feature-name
```

### 8. Create Pull Request

1. Go to the original repository
2. Click "Compare & pull request"
3. Fill in the PR template
4. Submit

## 🎯 Contribution Guidelines

### What We Accept

✅ Bug fixes  
✅ New features  
✅ Performance improvements  
✅ Documentation updates  
✅ Test coverage  
✅ Code refactoring  
✅ UI improvements  
✅ Platform support  

### What We Don't Accept

❌ Breaking changes without discussion  
❌ Unnecessary dependencies  
❌ Poorly tested code  
❌ Code that fails CI/CD  
❌ Non-responsive UI changes  
❌ Inconsistent with project style  

### Code Quality Standards

1. **Tests Required**
   - All new features need tests
   - Bug fixes need regression tests
   - Target 90%+ coverage

2. **Documentation**
   - Update README if needed
   - Add comments for complex logic
   - Document public APIs

3. **Performance**
   - No performance regression
   - Memory efficient
   - Battery friendly

4. **Accessibility**
   - Screen reader support
   - Proper contrast ratios
   - Keyboard navigation

5. **Cross-Platform**
   - Test on all platforms
   - Responsive design
   - Platform-specific considerations

## 🔍 Pull Request Process

### Before Submitting

- [ ] Code follows project style
- [ ] Tests pass
- [ ] Coverage maintained
- [ ] Documentation updated
- [ ] No linting errors

### PR Template

```markdown
## Description

Brief description of changes

## Type of Change

- [ ] Bug fix
- [ ] New feature
- [ ] Documentation
- [ ] Refactoring

## Testing

How did you test your changes?

## Screenshots

If applicable, add screenshots

## Checklist

- [ ] I have tested my changes
- [ ] I have added/updated tests
- [ ] I have updated documentation
- [ ] I have followed coding standards
```

### Review Process

1. **Automated Checks**
   - CI/CD pipeline runs
   - Tests execute
   - Code analysis

2. **Code Review**
   - At least one reviewer
   - Feedback provided
   - Changes requested

3. **Approval**
   - Reviewer approval
   - All checks pass
   - Merge

## 🏗️ Development Setup

### IDE Configuration

#### VS Code

```json
{
  "dart.flutterSdkPath": "/path/to/flutter",
  "editor.formatOnSave": true,
  "editor.rulers": [80],
  "files.trimTrailingWhitespace": true
}
```

#### Android Studio

1. Enable Dart/Flutter plugins
2. Configure Flutter SDK
3. Set code style to Flutter defaults

### Git Hooks

Optional pre-commit hook:

```bash
#!/bin/sh
flutter format .
flutter analyze
flutter test
```

## 🐛 Bug Reports

If you find a bug:

1. Search existing issues
2. Create new issue with:
   - Clear description
   - Steps to reproduce
   - Expected behavior
   - Actual behavior
   - Screenshots/Logs
   - Flutter version
   - Platform info

## 💡 Feature Requests

1. Search existing issues/PRs
2. Create new issue with:
   - Clear feature description
   - Use cases
   - Proposed implementation
   - Alternatives considered

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Material Design 3](https://m3.material.io)
- [BLoC Pattern](https://bloclibrary.dev)

## 🚦 Commit Message Convention

```
type(scope): subject

body

footer
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting, etc.
- `refactor`: Code change without feature
- `perf`: Performance improvement
- `test`: Adding tests
- `chore`: Maintenance

**Example:**
```
feat(player): add volume control

Added volume slider to player controls.
Allows users to adjust volume from 0-100%.

Closes #123
```

## 🙋 Getting Help

- Check [issues](https://github.com/imloafy/firefly/issues)
- Ask in discussions
- Review existing code
- Read documentation

## 🎉 Thank You!

Thank you for contributing to Firefly! Your help makes this project better for everyone. 🎵✨
