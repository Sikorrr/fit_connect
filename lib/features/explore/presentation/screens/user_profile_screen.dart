import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../constants/style_guide.dart';
import '../../../../utils/device_utils.dart';
import '../../../shared/data/models/user.dart';
import '../widgets/preferred_workout_times_section.dart';
import '../widgets/user_details_section.dart';
import '../widgets/user_profile_section.dart';

class UserProfileScreen extends StatelessWidget {
  final User user;

  const UserProfileScreen({super.key, required this.user});

  bool isTablet(BuildContext context) {
    return DeviceUtils.isTablet(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb ? null : AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserProfileSection(user: user),
              const Gap(Sizes.p16),
              UserDetailsSection(
                user: user,
              ),
              const Gap(Sizes.p16),
              PreferredWorkoutTimesSection(
                preferredWorkoutDayTimes: user.preferredWorkoutDayTimes,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
