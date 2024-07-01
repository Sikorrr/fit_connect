import 'package:injectable/injectable.dart';

import '../../../../core/api/response.dart';
import '../../../../core/api/result_status.dart';
import '../../../../core/error/error_manager.dart';
import '../../../shared/data/models/user.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/remote/message_remote_data_source.dart';
import '../models/conversation.dart';
import '../models/message.dart';

@LazySingleton(as: MessageRepository)
class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource _remoteDataSource;
  final ErrorManager _errorManager;

  MessageRepositoryImpl(this._remoteDataSource, this._errorManager);

  @override
  Future<Response<void>> sendMessage(
      String conversationId, Message message, List<User> participants) async {
    try {
      final conversationExists =
          await _remoteDataSource.conversationExists(conversationId);

      if (!conversationExists) {
        final newConversation = Conversation(
          id: conversationId,
          messages: [message],
          participantIds: participants.map((user) => user.id).toList(),
        );
        await _remoteDataSource.createConversation(
            conversationId, newConversation);
      } else {
        await _remoteDataSource.updateConversationMessages(
            conversationId, message);
      }
      return Response(ResultStatus.success);
    } catch (e, s) {
      return _handleException('failed_to_send_message', e: e, s: s);
    }
  }

  @override
  Stream<List<Conversation>> getAllConversations(String? userId) {
    return _remoteDataSource.getAllConversations(userId).handleError((e, s) =>
        _handleStreamException('failed_to_fetch_conversations', e: e, s: s));
  }

  @override
  Stream<Conversation> fetchConversation(String conversationId) {
    return _remoteDataSource.fetchConversation(conversationId).handleError(
        (e, s) =>
            _handleStreamException('failed_to_fetch_conversation', e: e, s: s));
  }

  @override
  Future<void> createConversation(
      String conversationId, Conversation conversation) async {
    try {
      await _remoteDataSource.createConversation(conversationId, conversation);
    } catch (e, s) {
      _handleException('failed_to_create_conversation', e: e, s: s);
    }
  }

  @override
  Future<void> updateConversationMessages(
      String conversationId, Message message) async {
    try {
      await _remoteDataSource.updateConversationMessages(
          conversationId, message);
    } catch (e, s) {
      _handleException('failed_to_update_conversation_messages', e: e, s: s);
    }
  }

  @override
  Future<bool> conversationExists(String conversationId) async {
    try {
      return await _remoteDataSource.conversationExists(conversationId);
    } catch (e, s) {
      _handleException('failed_to_check_conversation_exists', e: e, s: s);
      return false;
    }
  }

  Response<T> _handleException<T>(String message, {Object? e, StackTrace? s}) {
    return _errorManager.handleException(message, exception: e, stackTrace: s);
  }

  Stream<T> _handleStreamException<T>(String message,
      {Object? e, StackTrace? s}) {
    _errorManager.handleException(message, exception: e, stackTrace: s);
    return Stream.error(Exception(message));
  }
}
