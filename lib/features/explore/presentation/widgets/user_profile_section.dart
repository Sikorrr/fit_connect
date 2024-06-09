import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../constants/style_guide.dart';
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                  //TODO: Handle direct message action
                },
                icon: const Icon(Icons.message),
                label: Text('message'.tr()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
