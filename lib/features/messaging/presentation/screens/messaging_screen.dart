import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alerts/alert_service.dart';
import '../../../../core/dependency_injection/dependency_injection.dart';
import '../bloc/message_bloc.dart';
import '../bloc/message_state.dart';
import '../widgets/conversation_tile.dart';

class MessagingScreen extends StatelessWidget {
  const MessagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('messages'.tr()),
      ),
      body: BlocConsumer<MessageBloc, MessageState>(
        builder: (context, state) {
          if (state is ConversationsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ConversationsEmpty) {
            return Center(
              child: Text(
                'no_conversations_found'.tr(),
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          } else if (state is ConversationsLoadSuccess) {
            return ListView.builder(
              itemCount: state.conversations.length,
              itemBuilder: (context, index) {
                final conversation = state.conversations[index];
                final otherUser = conversation.otherUser;
                return ConversationTile(
                    conversation: conversation, otherUser: otherUser);
              },
            );
          }
          return const SizedBox.shrink();
        },
        listener: (BuildContext context, MessageState state) {
          if (state is ConversationsLoadFailure) {
            getIt<AlertService>()
                .showMessage(context, state.error, MessageType.error);
          }
        },
      ),
    );
  }
}
