import 'package:flutter/material.dart';
import 'package:firefly/core/themes/app_theme.dart';

/// Theme selector widget for switching between light/dark modes
class ThemeSelector extends StatefulWidget {
  final ValueChanged<ThemeMode> onThemeChanged;
  final ThemeMode currentTheme;

  const ThemeSelector({
    super.key,
    required this.onThemeChanged,
    required this.currentTheme,
  });

  @override
  State<ThemeSelector> createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  late ThemeMode _selectedTheme;

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.currentTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appearance',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildThemeOption(
              icon: Icons.dark_mode,
              label: 'Dark Mode',
              subtitle: 'Firefly black theme',
              value: ThemeMode.dark,
            ),
            const SizedBox(height: 12),
            _buildThemeOption(
              icon: Icons.light_mode,
              label: 'Light Mode',
              subtitle: 'Bright yellow theme',
              value: ThemeMode.light,
            ),
            const SizedBox(height: 12),
            _buildThemeOption(
              icon: Icons.brightness_auto,
              label: 'System Default',
              subtitle: 'Follow system theme',
              value: ThemeMode.system,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required IconData icon,
    required String label,
    required String subtitle,
    required ThemeMode value,
  }) {
    final isSelected = _selectedTheme == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTheme = value;
        });
        widget.onThemeChanged(value);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFFB300).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFFB300)
                : const Color(0xFF2A2A2A),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFFB300)
                    : const Color(0xFF2A2A2A),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? const Color(0xFF121212) : const Color(0xFFB3B3B3),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFFFFB300),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

/// Theme mode selector button
class ThemeModeButton extends StatefulWidget {
  final ThemeMode currentTheme;
  final ValueChanged<ThemeMode> onThemeChanged;

  const ThemeModeButton({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  State<ThemeModeButton> createState() => _ThemeModeButtonState();
}

class _ThemeModeButtonState extends State<ThemeModeButton> {
  late ThemeMode _currentTheme;

  @override
  void initState() {
    super.initState();
    _currentTheme = widget.currentTheme;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _currentTheme == ThemeMode.dark
            ? Icons.dark_mode
            : _currentTheme == ThemeMode.light
                ? Icons.light_mode
                : Icons.brightness_auto,
        color: const Color(0xFFB3B3B3),
      ),
      onPressed: () {
        final nextTheme = _currentTheme == ThemeMode.dark
            ? ThemeMode.light
            : _currentTheme == ThemeMode.light
                ? ThemeMode.system
                : ThemeMode.dark;

        setState(() {
          _currentTheme = nextTheme;
        });
        widget.onThemeChanged(nextTheme);
      },
      tooltip: 'Switch Theme',
    );
  }
}

/// Theme transition wrapper
class ThemeTransition extends StatefulWidget {
  final Widget child;
  final ThemeData theme;
  final Duration duration;

  const ThemeTransition({
    super.key,
    required this.child,
    required this.theme,
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  State<ThemeTransition> createState() => _ThemeTransitionState();
}

class _ThemeTransitionState extends State<ThemeTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(ThemeTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.theme != widget.theme) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Theme(
        data: widget.theme,
        child: widget.child,
      ),
    );
  }
}
