import 'package:flutter/material.dart';
import 'package:firefly/core/themes/app_theme.dart';

/// Custom Firefly-themed button with glow effect
class FireflyButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final bool hasGlow;

  const FireflyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.backgroundColor,
    this.textColor,
    this.hasGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: hasGlow
            ? LinearGradient(
                colors: [
                  backgroundColor ?? const Color(0xFFFFB300),
                  (backgroundColor ?? const Color(0xFFFFB300)).withOpacity(0.8),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: hasGlow ? null : (backgroundColor ?? const Color(0xFFFFB300)),
        boxShadow: hasGlow
            ? [
                BoxShadow(
                  color: (backgroundColor ?? const Color(0xFFFFB300))
                      .withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: (backgroundColor ?? const Color(0xFF6F00))
                      .withOpacity(0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: isLoading ? null : onPressed,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      color: textColor ?? const Color(0xFF121212),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Firefly-themed text field with animated border
class FireflyTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final bool readOnly;

  const FireflyTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
    this.validator,
    this.onTap,
    this.readOnly = false,
  });

  @override
  State<FireflyTextField> createState() => _FireflyTextFieldState();
}

class _FireflyTextFieldState extends State<FireflyTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _borderAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _borderAnimation = Tween<double>(begin: 1, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _borderAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isFocused
                  ? const Color(0xFFFFB300)
                  : const Color(0xFF2A2A2A),
              width: _borderAnimation.value,
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            onTapOutside: (event) {
              setState(() {
                _isFocused = false;
                _controller.reverse();
              });
            },
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon,
                      color: _isFocused
                          ? const Color(0xFFFFB300)
                          : const Color(0xFFB3B3B3))
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              filled: true,
              fillColor: Colors.transparent,
              labelStyle: TextStyle(
                color: _isFocused
                    ? const Color(0xFFFFB300)
                    : const Color(0xFFB3B3B3),
              ),
              hintStyle: const TextStyle(color: Color(0xFF666666)),
            ),
            style: const TextStyle(color: Colors.white),
            onFocusChange: (hasFocus) {
              setState(() {
                _isFocused = hasFocus;
                if (hasFocus) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              });
            },
          ),
        );
      },
    );
  }
}

/// Firefly shimmer loading effect
class FireflyShimmer extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const FireflyShimmer({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: child,
    );
  }
}

/// Firefly gradient card
class FireflyGradientCard extends StatelessWidget {
  final Widget child;
  final double? height;
  final double borderRadius;
  final List<Color> gradientColors;

  const FireflyGradientCard({
    super.key,
    required this.child,
    this.height,
    this.borderRadius = 16,
    this.gradientColors = const [
      Color(0xFFFFB300),
      Color(0xFFFF6F00),
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
      ),
    );
  }
}

/// Firefly icon button with ripple effect
class FireflyIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final Color? backgroundColor;
  final double size;
  final double iconSize;

  const FireflyIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconColor,
    this.backgroundColor,
    this.size = 48,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color(0xFF1E1E1E),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: iconColor ?? const Color(0xFFB3B3B3),
          size: iconSize,
        ),
      ),
    );
  }
}

/// Firefly page transition
class FireflyPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final AxisDirection direction;

  FireflyPageRoute({
    required this.child,
    this.direction = AxisDirection.right,
  }) : super(
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
        .chain(CurveTween(curve: Curves.easeOutCubic));

    return SlideTransition(
      position: animation.drive(tween),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}
