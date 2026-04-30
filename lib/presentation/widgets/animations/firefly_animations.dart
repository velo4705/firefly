import 'package:flutter/material.dart';

/// Collection of Firefly-themed animations
class FireflyAnimations {
  /// Firefly pulse animation (for glowing effect)
  static Animation<double> createPulseAnimation(AnimationController controller) {
    return Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  /// Bounce animation
  static Animation<double> createBounceAnimation(AnimationController controller) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ),
    );
  }

  /// Fade slide up animation
  static Animation<double> createFadeSlideUp(
    AnimationController controller,
  ) {
    return Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  /// Scale animation
  static Animation<double> createScaleAnimation(
    AnimationController controller, {
    double begin = 0.0,
    double end = 1.0,
  }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ),
    );
  }

  /// Rotation animation
  static Animation<double> createRotationAnimation(
    AnimationController controller, {
    double turns = 1.0,
  }) {
    return Tween<double>(begin: 0.0, end: turns).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ),
    );
  }
}

/// Staggered animation for list items
class StaggeredAnimation {
  final AnimationController controller;
  final List<Animation<double>> animations = [];

  StaggeredAnimation({
    required this.controller,
    required int itemCount,
    Duration delay = const Duration(milliseconds: 100),
  }) {
    for (var i = 0; i < itemCount; i++) {
      final startTime = delay * i;
      final duration = const Duration(milliseconds: 300);

      animations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              startTime.inMilliseconds / 1000,
              (startTime + duration).inMilliseconds / 1000,
              curve: Curves.easeOut,
            ),
          ),
        ),
      );
    }
  }
}

/// Firefly particle for background effect
class FireflyParticle {
  Offset position;
  Offset velocity;
  double size;
  Color color;
  double opacity;

  FireflyParticle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.color,
    this.opacity = 1.0,
  });

  void update(Duration duration) {
    position += velocity * (duration.inMilliseconds / 1000);
    opacity -= 0.001;
  }

  bool get isDead => opacity <= 0;
}

/// Background animation painter with firefly particles
class FireflyBackgroundPainter extends CustomPainter {
  final List<FireflyParticle> particles;

  FireflyBackgroundPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      paint.color = particle.color.withOpacity(particle.opacity);
      canvas.drawCircle(
        particle.position,
        particle.size,
        paint,
      );

      // Add glow effect
      paint.maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        8,
      );
      canvas.drawCircle(
        particle.position,
        particle.size * 2,
        paint,
      );
      paint.maskFilter = null;
    }
  }

  @override
  bool shouldRepaint(FireflyBackgroundPainter oldDelegate) {
    return true;
  }
}

/// Wave animation for audio equalizer
class WaveAnimationPainter extends CustomPainter {
  final List<double> values;
  final Color color;

  WaveAnimationPainter({
    required this.values,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    if (values.isEmpty) return;

    final width = size.width;
    final height = size.height;
    final step = width / values.length;

    final path = Path();
    path.moveTo(0, height / 2);

    for (var i = 0; i < values.length; i++) {
      final x = i * step;
      final y = (height / 2) - (values[i] * height / 2);
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WaveAnimationPainter oldDelegate) {
    return values != oldDelegate.values;
  }
}

/// Animated border for focus states
class AnimatedFocusBorder extends StatefulWidget {
  final Widget child;
  final bool isFocused;
  final Duration duration;
  final Color focusedColor;
  final Color unfocusedColor;

  const AnimatedFocusBorder({
    super.key,
    required this.child,
    required this.isFocused,
    this.duration = const Duration(milliseconds: 300),
    this.focusedColor = const Color(0xFFFFB300),
    this.unfocusedColor = const Color(0xFF2A2A2A),
  });

  @override
  State<AnimatedFocusBorder> createState() => _AnimatedFocusBorderState();
}

class _AnimatedFocusBorderState extends State<AnimatedFocusBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _colorAnimation = ColorTween(
      begin: widget.unfocusedColor,
      end: widget.focusedColor,
    ).animate(_controller);
  }

  @override
  void didUpdateWidget(AnimatedFocusBorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFocused != oldWidget.isFocused) {
      if (widget.isFocused) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _colorAnimation.value ?? widget.unfocusedColor,
              width: 2,
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
