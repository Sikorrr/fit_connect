import 'package:fit_connect/common_widgets/responsive_center.dart';
import 'package:flutter/material.dart';

import '../../../constants/style_guide.dart';

class CustomScaffold extends StatelessWidget {
  final Widget child;

  const CustomScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p24),
        child: ResponsiveCenter(
          child: child,
        ),
      ),
    );
  }
}
