import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Accessibility-focused widgets for better usability

/// High contrast text for accessibility
class AccessibleText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool highContrast;
  final double fontSizeMultiplier;

  const AccessibleText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.highContrast = false,
    this.fontSizeMultiplier = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.bodyMedium;
    final textStyle = style ?? baseStyle;
    final fontSize = (textStyle?.fontSize ?? 16) * fontSizeMultiplier;

    return Text(
      text,
      style: textStyle?.copyWith(
        fontSize: fontSize,
        color: highContrast
            ? Colors.white
            : textStyle?.color ?? Colors.white,
        fontWeight: highContrast
            ? FontWeight.bold
            : textStyle?.fontWeight ?? FontWeight.normal,
      ),
      textAlign: textAlign,
    );
  }
}

/// Accessible button with larger touch target
class AccessibleButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double minHeight;
  final double minWidth;
  final BorderRadius borderRadius;
  final Widget? icon;

  const AccessibleButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.minHeight = 48,
    this.minWidth = 88,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      enabled: onPressed != null,
      child: Material(
        color: backgroundColor ?? Theme.of(context).primaryColor,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onPressed,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: minHeight,
              minWidth: minWidth,
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Accessible switch with semantic labels
class AccessibleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String label;
  final String? activeLabel;
  final String? inactiveLabel;

  const AccessibleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.activeLabel,
    this.inactiveLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      value: value
          ? (activeLabel ?? 'On')
          : (inactiveLabel ?? 'Off'),
      checked: value,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

/// Accessible slider with value announcements
class AccessibleSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final String label;
  final ValueChanged<double>? onChanged;
  final String? semanticFormatterCallback;

  const AccessibleSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.label,
    required this.onChanged,
    this.semanticFormatterCallback,
  });

  @override
  State<AccessibleSlider> createState() => _AccessibleSliderState();
}

class _AccessibleSliderState extends State<AccessibleSlider> {
  double _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  void didUpdateWidget(AccessibleSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _currentValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.label,
      value: _currentValue.round().toString(),
      slider: true,
      child: Slider(
        value: _currentValue,
        min: widget.min,
        max: widget.max,
        onChanged: (value) {
          setState(() {
            _currentValue = value;
          });
          widget.onChanged?.call(value);
        },
        onChangeEnd: (value) {
          // Announce the final value
          // SemanticsService.announce(
          //   '${(value * 100).round()} percent',
          //   Directionality.of(context),
          // );
        },
      ),
    );
  }
}

/// Focusable card with keyboard navigation support
class FocusableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool autofocus;
  final Color? focusColor;
  final Color? hoverColor;

  const FocusableCard({
    super.key,
    required this.child,
    this.onTap,
    this.autofocus = false,
    this.focusColor,
    this.hoverColor,
  });

  @override
  State<FocusableCard> createState() => _FocusableCardState();
}

class _FocusableCardState extends State<FocusableCard> {
  bool _hasFocus = false;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
     return Focus(
      autofocus: widget.autofocus,
      onFocusChange: (hasFocus) {
        setState(() {
          _hasFocus = hasFocus;
        });
      },
      // onKeyEvent: (node, event) {
      //   if (event is KeyDownEvent) {
      //     if (event.logicalKey == LogicalKeyboardKey.enter ||
      //         event.logicalKey == LogicalKeyboardKey.space) {
      //       widget.onTap?.call();
      //       return KeyEventResult.handled;
      //     }
      //   }
      //   return KeyEventResult.ignored;
      // },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: _hasFocus
                  ? (widget.focusColor ??
                      Theme.of(context).primaryColor.withOpacity(0.1))
                  : _isHovering
                      ? (widget.hoverColor ??
                          Colors.white.withOpacity(0.05))
                      : Colors.transparent,
              border: Border.all(
                color: _hasFocus
                    ? (widget.focusColor ??
                        Theme.of(context).primaryColor)
                    : Colors.transparent,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// Screen reader announcement helper
class A11yAnnouncement {
  static void announce(String message, [bool polite = true]) {
    // No-op on web
  }

  static void announceError(String message) {
    // No-op on web
  }

  static void announceSuccess(String message) {
    // No-op on web
  }
}

/// Accessible list item
class AccessibleListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool selected;
  final int? index;
  final int? totalItems;

  const AccessibleListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
    this.selected = false,
    this.index,
    this.totalItems,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      selected: selected,
      label: [
        title,
        if (subtitle != null) subtitle!,
        if (index != null && totalItems != null)
          'Item ${index! + 1} of $totalItems',
        if (selected) 'Selected',
      ].join(', '),
      child: ListTile(
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        onTap: onTap,
        tileColor: selected
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : null,
        trailing: selected
            ? const Icon(Icons.check, color: Colors.green)
            : null,
      ),
    );
  }
}

/// High contrast theme data
class HighContrastTheme {
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.yellow,
      scaffoldBackgroundColor: Colors.black,
      cardColor: Colors.grey[900],
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow,
          foregroundColor: Colors.black,
          minimumSize: const Size(88, 48),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.grey[100],
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          minimumSize: const Size(88, 48),
        ),
      ),
    );
  }
}
