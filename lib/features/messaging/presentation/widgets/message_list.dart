import 'package:flutter/material.dart';

import '../../../../constants/style_guide.dart';
import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../../../core/state/app_state.dart';
import '../../data/models/message.dart';
import 'message_tile.dart';

class MessageList extends StatelessWidget {
  final List<Message> messages;

  const MessageList({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    final currentUser = getIt<AppState>().user!;
    return ListView.builder(
      padding: const EdgeInsets.all(Sizes.p8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isCurrentUser = message.authorId == currentUser.id;
        return MessageTile(message: message, isCurrentUser: isCurrentUser);
      },
    );
  }
}
