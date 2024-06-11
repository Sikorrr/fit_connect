import 'package:equatable/equatable.dart';

import '../../data/models/conversation.dart';
import '../../data/models/message.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object?> get props => [];
}

class MessageInitial extends MessageState {}

class MessageSentSuccess extends MessageState {}

class MessageSentFailure extends MessageState {
  final String error;

  const MessageSentFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class ConversationsLoading extends MessageState {}

class ConversationsLoadSuccess extends MessageState {
  final List<Conversation> conversations;

  const ConversationsLoadSuccess({required this.conversations});

  @override
  List<Object?> get props => [conversations];
}

class ConversationsLoadFailure extends MessageState {
  final String error;

  const ConversationsLoadFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class MessagesLoading extends MessageState {}

class MessagesLoaded extends MessageState {
  final List<Message> messages;

  const MessagesLoaded(this.messages);
}

class MessageError extends MessageState {
  final String error;

  const MessageError(this.error);
}
