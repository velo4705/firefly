import 'package:flutter/material.dart';

/// Gesture control handlers for player interactions
class PlayerGestureControls extends StatefulWidget {
  final Widget child;
  final Function()? onTap;
  final Function()? onDoubleTap;
  final Function(DragUpdateDetails)? onHorizontalDragUpdate;
  final Function(DragEndDetails)? onHorizontalDragEnd;
  final Function(DragUpdateDetails)? onVerticalDragUpdate;
  final double swipeThreshold;
  final double seekSensitivity;

  const PlayerGestureControls({
    super.key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    this.onVerticalDragUpdate,
    this.swipeThreshold = 100.0,
    this.seekSensitivity = 1.0,
  });

  @override
  State<PlayerGestureControls> createState() => _PlayerGestureControlsState();
}

class _PlayerGestureControlsState extends State<PlayerGestureControls> {
  double _dragStartX = 0;
  double _dragStartY = 0;
  Duration _seekStartPosition = Duration.zero;
  double _volumeStart = 1.0;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onDoubleTap: widget.onDoubleTap,
      onHorizontalDragStart: (details) {
        setState(() {
          _isDragging = true;
          _dragStartX = details.localPosition.dx;
        });
      },
      onHorizontalDragUpdate: (details) {
        final deltaX = details.localPosition.dx - _dragStartX;
        widget.onHorizontalDragUpdate?.call(details);

        // Horizontal drag = seek
        if (widget.onHorizontalDragUpdate != null) {
          _seekStartPosition = Duration(
            milliseconds: (deltaX * widget.seekSensitivity).round(),
          );
        }
      },
      onHorizontalDragEnd: (details) {
        setState(() {
          _isDragging = false;
        });
        widget.onHorizontalDragEnd?.call(details);
      },
      onVerticalDragStart: (details) {
        setState(() {
          _isDragging = true;
          _dragStartY = details.localPosition.dy;
        });
      },
      onVerticalDragUpdate: (details) {
        final deltaY = details.localPosition.dy - _dragStartY;
        widget.onVerticalDragUpdate?.call(details);

        // Vertical drag = volume control (right side) or brightness (left side)
        final screenWidth = MediaQuery.of(context).size.width;
        final isRightSide = _dragStartX > screenWidth / 2;

        if (isRightSide) {
          // Volume control
          final deltaVolume = -deltaY / 100;
          // Volume logic would be handled by parent
        }
      },
      child: widget.child,
    );
  }
}

/// Swipeable card with dismiss gesture
class SwipeableCard extends StatefulWidget {
  final Widget child;
  final Function()? onSwipeLeft;
  final Function()? onSwipeRight;
  final Color? background;
  final IconData? leftIcon;
  final IconData? rightIcon;

  const SwipeableCard({
    super.key,
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.background,
    this.leftIcon = Icons.delete,
    this.rightIcon = Icons.check,
  });

  @override
  State<SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  double _dragOffset = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragOffset += details.delta.dx;
        });
      },
      onHorizontalDragEnd: (details) {
        if (_dragOffset.abs() > 100) {
          if (_dragOffset > 0) {
            widget.onSwipeRight?.call();
          } else {
            widget.onSwipeLeft?.call();
          }
        } else {
          setState(() {
            _dragOffset = 0;
          });
        }
      },
      child: Transform.translate(
        offset: Offset(_dragOffset, 0),
        child: widget.child,
      ),
    );
  }
}

/// Long press gesture handler
class LongPressHandler extends StatefulWidget {
  final Widget child;
  final Function()? onLongPress;
  final Duration longPressDuration;

  const LongPressHandler({
    super.key,
    required this.child,
    this.onLongPress,
    this.longPressDuration = const Duration(milliseconds: 500),
  });

  @override
  State<LongPressHandler> createState() => _LongPressHandlerState();
}

class _LongPressHandlerState extends State<LongPressHandler>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isLongPressing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.longPressDuration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressDown: (details) {
        setState(() {
          _isLongPressing = true;
        });
        _controller.forward().then((_) {
          if (mounted) {
            widget.onLongPress?.call();
            setState(() {
              _isLongPressing = false;
            });
          }
        });
      },
      onLongPressUp: () {
        setState(() {
          _isLongPressing = false;
        });
        _controller.reset();
      },
      onLongPressCancel: () {
        setState(() {
          _isLongPressing = false;
        });
        _controller.reset();
      },
      child: Opacity(
        opacity: _isLongPressing ? 0.7 : 1.0,
        child: widget.child,
      ),
    );
  }
}
