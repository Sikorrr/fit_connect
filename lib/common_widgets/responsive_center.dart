import 'package:flutter/material.dart';

import '../constants/style_guide.dart';

class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({
    super.key,
    this.padding = EdgeInsets.zero,
    required this.child,
  });

  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Sizes.maxScreenWidth,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
