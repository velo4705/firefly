import 'package:flutter/material.dart';

/// Responsive layout breakpoints
class AppBreakpoints {
  static const double mobile = 0;
  static const double mobileLarge = 480;
  static const smallTablet = 600;
  static const tablet = 768;
  static const smallDesktop = 1024;
  static const desktop = 1200;
  static const largeDesktop = 1440;

  /// Get device type based on screen width
  static DeviceType getDeviceType(double width) {
    if (width < smallTablet) {
      return DeviceType.mobile;
    } else if (width < tablet) {
      return DeviceType.smallTablet;
    } else if (width < smallDesktop) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// Get content width based on screen size
  static double getContentWidth(double screenWidth) {
    if (screenWidth < tablet) {
      return screenWidth;
    } else if (screenWidth < smallDesktop) {
      return 720;
    } else if (screenWidth < desktop) {
      return 960;
    } else {
      return 1200;
    }
  }

  /// Get responsive padding
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < tablet) {
      return const EdgeInsets.all(16);
    } else if (width < smallDesktop) {
      return const EdgeInsets.all(24);
    } else {
      return const EdgeInsets.all(32);
    }
  }

  /// Get responsive font size
  static double getResponsiveFontSize(BuildContext context, {
    required double mobileSize,
    required double desktopSize,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width < tablet) {
      return mobileSize;
    } else {
      return desktopSize;
    }
  }
}

enum DeviceType { mobile, smallTablet, tablet, desktop }

/// Responsive widget builder
class ResponsiveBuilder extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? child;
  final bool useLayoutBuilder;

  const ResponsiveBuilder({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
    this.child,
    this.useLayoutBuilder = false,
  });

  @override
  Widget build(BuildContext context) {
    if (useLayoutBuilder) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return _buildWithConstraints(constraints.maxWidth, context);
        },
      );
    }

    return _buildWithConstraints(MediaQuery.of(context).size.width, context);
  }

  Widget _buildWithConstraints(double width, BuildContext context) {
    final deviceType = AppBreakpoints.getDeviceType(width);

    switch (deviceType) {
      case DeviceType.mobile:
      case DeviceType.smallTablet:
        return mobile ?? child ?? const SizedBox.shrink();
      case DeviceType.tablet:
        return tablet ?? child ?? const SizedBox.shrink();
      case DeviceType.desktop:
        return desktop ?? child ?? const SizedBox.shrink();
    }
  }
}

/// Responsive grid layout
class ResponsiveGrid extends StatelessWidget {
  final int mobileCrossAxisCount;
  final int tabletCrossAxisCount;
  final int desktopCrossAxisCount;
  final double childAspectRatio;
  final double spacing;
  final List<Widget> children;

  const ResponsiveGrid({
    super.key,
    this.mobileCrossAxisCount = 2,
    this.tabletCrossAxisCount = 3,
    this.desktopCrossAxisCount = 4,
    this.childAspectRatio = 1.0,
    this.spacing = 8,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: GridView.count(
        crossAxisCount: mobileCrossAxisCount,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
        padding: const EdgeInsets.all(8),
        children: children,
      ),
      tablet: GridView.count(
        crossAxisCount: tabletCrossAxisCount,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
        padding: const EdgeInsets.all(12),
        children: children,
      ),
      desktop: GridView.count(
        crossAxisCount: desktopCrossAxisCount,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
        padding: const EdgeInsets.all(16),
        children: children,
      ),
    );
  }
}

/// Adaptive card layout
class AdaptiveCardLayout extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  const AdaptiveCardLayout({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: ListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
        contentPadding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        dense: true,
      ),
      tablet: desktop ??
          ListTile(
            leading: leading,
            title: title,
            subtitle: subtitle,
            trailing: trailing,
            onTap: onTap,
            contentPadding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
          ),
      desktop: Card(
        margin: padding != null
            ? null
            : const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: 16)],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null) title!,
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        subtitle!,
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 16), trailing!],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? get desktop => trailing != null
      ? Card(
          margin: padding != null
              ? null
              : const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: ListTile(
            leading: leading,
            title: title,
            subtitle: subtitle,
            trailing: trailing,
            onTap: onTap,
            contentPadding: padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        )
      : null;
}

/// Responsive value selector
class ResponsiveValue<T> {
  final T mobile;
  final T? smallTablet;
  final T? tablet;
  final T? desktop;

  const ResponsiveValue({
    required this.mobile,
    this.smallTablet,
    this.tablet,
    this.desktop,
  });

  T getValue(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final deviceType = AppBreakpoints.getDeviceType(width);

    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.smallTablet:
        return smallTablet ?? mobile;
      case DeviceType.tablet:
        return tablet ?? smallTablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? smallTablet ?? mobile;
    }
  }
}

/// Responsive spacing
class ResponsiveSpacing extends StatelessWidget {
  final double? mobile;
  final double? smallTablet;
  final double? tablet;
  final double? desktop;
  final Axis axis;

  const ResponsiveSpacing({
    super.key,
    required this.mobile,
    this.smallTablet,
    this.tablet,
    this.desktop,
    this.axis = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveValue<double>(
      mobile: mobile ?? 0,
      smallTablet: smallTablet ?? mobile,
      tablet: tablet ?? smallTablet ?? mobile,
      desktop: desktop ?? tablet ?? smallTablet ?? mobile,
    ).getValue(context);

    return SizedBox(
      width: axis == Axis.horizontal ? spacing : null,
      height: axis == Axis.vertical ? spacing : null,
    );
  }
}

/// Responsive text
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? mobileStyle;
  final TextStyle? smallTabletStyle;
  final TextStyle? tabletStyle;
  final TextStyle? desktopStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText(
    this.text, {
    super.key,
    this.mobileStyle,
    this.smallTabletStyle,
    this.tabletStyle,
    this.desktopStyle,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final style = ResponsiveValue<TextStyle?>(
      mobile: mobileStyle,
      smallTablet: smallTabletStyle,
      tablet: tabletStyle,
      desktop: desktopStyle,
    ).getValue(context);

    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
