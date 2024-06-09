import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../constants/style_guide.dart';
import '../../../shared/data/models/user.dart';
import 'interest_chip_widget.dart';

class UserTile extends StatelessWidget {
  final User user;
  final VoidCallback onTap;

  const UserTile({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(Sizes.p12),
        padding: const EdgeInsets.all(Sizes.p16),
        decoration: Decorations.tileDecoration(),
        child: Row(
          children: [
            CircleAvatar(
              radius: Sizes.userAvatarSmallSize,
              backgroundImage: NetworkImage(user.imageUrl),
            ),
            const Gap(Sizes.p16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Gap(Sizes.p4),
                  Text(
                    user.bio.isNotEmpty ? user.bio : 'no_bio'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600],
                        ),
                  ),
                  const Gap(Sizes.p8),
                  InterestChipsWidget(
                    interests: user.fitnessInterests,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Sizes.iconColor,
              size: Sizes.iconSize,
            ),
          ],
        ),
      ),
    );
  }
}
