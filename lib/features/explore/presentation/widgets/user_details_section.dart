import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../constants/style_guide.dart';
import '../../../shared/data/models/user.dart';
import 'interest_chip_widget.dart';

class UserDetailsSection extends StatelessWidget {
  final User user;

  const UserDetailsSection({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const Gap(Sizes.p8),
        Text(
          'bio'.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Gap(Sizes.p8),
        Text(
          user.bio.isNotEmpty ? user.bio : 'no_bio'.tr(),
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey[600],
          ),
        ),
        const Gap(Sizes.p16),
        Text(
          'fitness_interests'.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Gap(Sizes.p8),
        InterestChipsWidget(
          interests: user.fitnessInterests,
        ),
      ],
    );
  }
}
