import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alerts/alert_service.dart';
import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../../../core/state/app_state.dart';
import '../../../shared/data/models/user.dart';
import '../../data/models/conversation.dart';
import '../bloc/message_bloc.dart';
import '../bloc/message_event.dart';
import '../bloc/message_state.dart';
import '../widgets/message_input.dart';
import '../widgets/message_list.dart';

class DirectMessageScreen extends StatefulWidget {
  final User otherUser;
  final Conversation? conversation;

  const DirectMessageScreen(
      {super.key, required this.otherUser, this.conversation});

  @override
  State<DirectMessageScreen> createState() => _DirectMessageScreenState();
}

class _DirectMessageScreenState extends State<DirectMessageScreen> {
  late final String conversationId;

  @override
  void initState() {
    super.initState();
    conversationId = context
        .read<MessageBloc>()
        .getConversationId(getIt<AppState>().user!.id, widget.otherUser.id);
    if (widget.conversation == null) {
      context.read<MessageBloc>().add(LoadConversationEvent(conversationId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUser.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<MessageBloc, MessageState>(
              builder: (context, state) {
                if (state is MessagesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MessagesLoaded) {
                  return MessageList(messages: state.messages);
                } else {
                  return widget.conversation != null
                      ? MessageList(messages: widget.conversation!.messages)
                      : Center(child: Text("no_messages_yet".tr()));
                }
              },
              listener: (context, state) {
                if (state is MessageError) {
                  getIt<AlertService>()
                      .showMessage(context, state.error, MessageType.error);
                } else if (state is MessageSentFailure) {
                  getIt<AlertService>()
                      .showMessage(context, state.error, MessageType.error);
                }
              },
            ),
          ),
          MessageInput(
            onSend: (messageText) {
              context.read<MessageBloc>().add(SendMessageEvent(
                    conversationId,
                    messageText,
                    [getIt<AppState>().user!, widget.otherUser],
                  ));
            },
          ),
        ],
      ),
    );
  }
}
