import 'package:equatable/equatable.dart';

import '../../../shared/data/models/user.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object?> get props => [];
}

class SendMessageEvent extends MessageEvent {
  final String conversationId;
  final String messageContent;
  final List<User> participants;

  const SendMessageEvent(
      this.conversationId, this.messageContent, this.participants);

  @override
  List<Object?> get props => [conversationId, messageContent, participants];
}

class LoadAllConversationsEvent extends MessageEvent {
  const LoadAllConversationsEvent();
}

class LoadConversationEvent extends MessageEvent {
  final String conversationId;

  const LoadConversationEvent(this.conversationId);
}
