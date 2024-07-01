import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/constants.dart';
import '../../../../constants/style_guide.dart';
import '../../../../utils/dialog_utils.dart';
import '../../../navigation/data/routes/router.dart';
import '../../../shared/data/models/user.dart';

class UserProfileSection extends StatelessWidget {
  final User user;

  const UserProfileSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: Sizes.userAvatarLargeSize,
            backgroundImage: NetworkImage(user.imageUrl),
          ),
          const Gap(Sizes.p16),
          Wrap(
            spacing: Sizes.p8,
            alignment: WrapAlignment.center,
            runSpacing: Sizes.p8,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  //TODO: Handle poke action
                },
                icon: const Icon(Icons.waving_hand_sharp),
                label: Text("poke".tr()),
              ),
              const Gap(Sizes.p8),
              ElevatedButton.icon(
                onPressed: () {
                  context.replace(
                      '${Routes.messages.path}/${Routes.directMessage.path}${user.id}',
                      extra: {
                        NavigationConstants.userKey: user,
                      });
                },
                icon: const Icon(Icons.message),
                label: Text('message'.tr()),
              ),
              const Gap(Sizes.p8),
              ElevatedButton.icon(
                onPressed: () async {
                  _showNewSessionDialog(context);
                },
                icon: const Icon(Icons.sports_handball),
                label: Text('schedule_workout'.tr()),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _showNewSessionDialog(BuildContext context) {
    showSessionDialog(
      context,
      user: user,
      availableActivities: user.fitnessInterests,
    );
  }
}
