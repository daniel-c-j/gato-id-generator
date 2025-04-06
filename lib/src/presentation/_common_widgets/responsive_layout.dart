import 'package:flutter/material.dart';

import '../../core/constants/_constants.dart';
import '../../util/context_shortcut.dart';

/// Responsive screensizes layout support.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    this.width,
    required this.desktop,
    required this.tablet,
    required this.mobile,
    required this.wearOS,
  });

  final double? width;
  final Widget desktop;
  final Widget tablet;
  final Widget mobile;
  final Widget wearOS;

  @override
  Widget build(BuildContext context) => switch (width ?? kScreenWidth(context)) {
        > Breakpoint.DESKTOP => desktop,
        > Breakpoint.TABLET => tablet,
        > Breakpoint.MOBILE => mobile,
        _ => wearOS
      };
}
