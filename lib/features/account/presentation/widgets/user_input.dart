import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../common_widgets/custom_button.dart';
import '../../../../common_widgets/responsive_center.dart';
import '../../../../constants/sizes.dart';

class UserInput extends StatelessWidget {
  const UserInput({
    super.key,
    required this.title,
    required this.child,
    required this.isEditing,
    this.isFullscreen = false,
    required this.onPressed,
  });

  final String title;
  final Widget child;
  final bool isFullscreen;
  final bool isEditing;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ResponsiveCenter(
      child: Container(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Gap(Sizes.p24),
            isFullscreen
                ? Expanded(
                    child: Center(
                      child: child,
                    ),
                  )
                : Center(child: child),
            const Gap(Sizes.p24),
            CustomButton(
              onPressed: onPressed,
              label: isEditing ? 'Save' : 'Next',
            ),
          ],
        ),
      ),
    );
  }
}
