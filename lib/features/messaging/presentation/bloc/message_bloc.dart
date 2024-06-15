import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fit_connect/features/shared/domain/repositories/user_repository.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/api/result_status.dart';
import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../../../core/state/app_state.dart';
import '../../../shared/data/models/user.dart';
import '../../data/models/conversation.dart';
import '../../data/models/message.dart';
import '../../domain/repositories/message_repository.dart';
import 'message_event.dart';
import 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepository _messageRepository;
  final UserRepository _userRepository;

  MessageBloc(this._messageRepository, this._userRepository)
      : super(MessageInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<LoadAllConversationsEvent>(_onLoadAllConversations);
    on<LoadConversationEvent>(_onLoadConversation);
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<MessageState> emit) async {
    final user = getIt<AppState>().user!;
    final message = Message(
      id: const Uuid().v4(),
      content: event.messageContent,
      timestamp: Timestamp.now(),
      authorId: user.id,
    );

    final response = await _messageRepository.sendMessage(
        event.conversationId, message, event.participants);
    if (response.result == ResultStatus.success) {
      emit(MessageSentSuccess());
      final conversation = await _messageRepository
          .fetchConversation(event.conversationId)
          .first;
      emit(MessagesLoaded(conversation.messages));
    } else {
      emit(MessageSentFailure(
          error: response.message ?? 'failed_to_send_message'.tr()));
    }
  }

  Future<void> _onLoadAllConversations(
      LoadAllConversationsEvent event, Emitter<MessageState> emit) async {
    emit(ConversationsLoading());
    final user = getIt<AppState>().user;
    final response =
        await _messageRepository.getAllConversations(user?.id).first;
    if (response.isNotEmpty) {
      final updatedConversations =
          await _updateConversationsWithUserDetails(response, user);
      emit(ConversationsLoadSuccess(conversations: updatedConversations));
    } else {
      emit(ConversationsEmpty());
    }
  }

  Future<List<Conversation>> _updateConversationsWithUserDetails(
      List<Conversation> conversations, User? user) async {
    final updatedConversations = <Conversation>[];
    for (var conversation in conversations) {
      final otherUserId =
          conversation.participantIds.firstWhere((id) => id != user?.id);
      final response = await _userRepository.getUserProfile(otherUserId);
      if (response.result == ResultStatus.success && response.data != null) {
        updatedConversations
            .add(conversation.copyWith(otherUser: response.data));
      } else {
        updatedConversations.add(conversation);
      }
    }
    return updatedConversations;
  }

  Future<void> _onLoadConversation(
      LoadConversationEvent event, Emitter<MessageState> emit) async {
    await emit.forEach<Conversation>(
      _messageRepository.fetchConversation(event.conversationId),
      onData: (conversation) => MessagesLoaded(conversation.messages),
      onError: (error, stackTrace) =>
          MessageError('failed_to_fetch_conversation'.tr()),
    );
  }

  String getConversationId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode
        ? '$userId1\_$userId2'
        : '$userId2\_$userId1';
  }
}
