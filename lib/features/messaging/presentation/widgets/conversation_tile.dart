import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/shimmer.dart';
import '../../../../constants/constants.dart';
import '../../../navigation/data/routes/router.dart';
import '../../../shared/data/models/user.dart';
import '../../data/models/conversation.dart';

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final User? otherUser;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.otherUser,
  });

  @override
  Widget build(BuildContext context) {
    if (otherUser == null) {
      return const ShimmerWidget(width: 200);
    }
    return ListTile(
      title: Text(otherUser!.name),
      subtitle: Text(conversation.messages.isNotEmpty
          ? conversation.messages.last.content
          : 'no_messages'.tr()),
      onTap: () {
        context.go(
            '${Routes.messages.path}/${Routes.directMessage.path}${otherUser!.name}',
            extra: {
              NavigationConstants.userKey: otherUser,
              NavigationConstants.conversationKey: conversation,
            });
      },
    );
  }
}
