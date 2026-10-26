import 'package:flutter/material.dart';

/// Standard Material 3 window size breakpoints for cross-platform layouts.
class Breakpoints {
  Breakpoints._();

  /// Phones in portrait (< 680px).
  static const double compact = 680;

  /// Tablets / foldables / small desktop windows (680px - 1024px).
  static const double medium = 1024;

  static bool isCompact(double width) => width < compact;
  static bool isWide(double width) => width >= compact;
  static bool isExpanded(double width) => width >= medium;
}

/// Centers content within a maximum width and adapts horizontal/vertical
/// padding for mobile, tablet, and desktop screens.
class ResponsiveBody extends StatelessWidget {
  const ResponsiveBody({
    super.key,
    required this.child,
    this.maxWidth = 1080,
    this.scrollable = true,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final bool scrollable;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = Breakpoints.isWide(constraints.maxWidth);
          final isExpanded = Breakpoints.isExpanded(constraints.maxWidth);
          final horizontal = isExpanded ? 40.0 : (isWide ? 28.0 : 20.0);
          final vertical = isWide ? 24.0 : 12.0;
          final effectivePadding = padding ??
              EdgeInsets.fromLTRB(horizontal, vertical, horizontal, 32);

          final content = Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Padding(
                padding: effectivePadding,
                child: child,
              ),
            ),
          );

          if (!scrollable) return content;
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: content,
          );
        },
      ),
    );
  }
}

/// Renders [left] and [right] side-by-side on wide screens (>= 680px),
/// and stacked vertically in a Column on compact screens (< 680px).
class ResponsiveSplit extends StatelessWidget {
  const ResponsiveSplit({
    super.key,
    required this.left,
    required this.right,
    this.leftFlex = 5,
    this.rightFlex = 6,
    this.spacing = 24,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final Widget left;
  final Widget right;
  final int leftFlex;
  final int rightFlex;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (Breakpoints.isWide(constraints.maxWidth)) {
          return Row(
            crossAxisAlignment: crossAxisAlignment,
            children: [
              Expanded(flex: leftFlex, child: left),
              SizedBox(width: spacing),
              Expanded(flex: rightFlex, child: right),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            left,
            SizedBox(height: spacing),
            right,
          ],
        );
      },
    );
  }
}
