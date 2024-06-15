import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../constants/style_guide.dart';
import '../../../../utils/date_utils.dart';
import '../../data/models/message.dart';

class MessageTile extends StatelessWidget {
  final Message message;
  final bool isCurrentUser;

  const MessageTile({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: Sizes.p4),
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(Sizes.defaultRadius),
            ),
            padding: const EdgeInsets.all(Sizes.p12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.content,
                  style: TextStyle(
                      color: isCurrentUser ? Colors.white : Colors.black),
                ),
                const Gap(Sizes.p4),
                Text(formatTimestamp(message.timestamp),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
