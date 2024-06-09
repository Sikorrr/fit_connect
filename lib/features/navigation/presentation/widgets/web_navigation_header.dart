import 'package:flutter/material.dart';

import '../../../../constants/style_guide.dart';

class NavigationHeader extends StatelessWidget {
  const NavigationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.p64,
      child: DrawerHeader(
        child: Text(
          'FitConnect',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
