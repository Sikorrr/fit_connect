import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fit_connect/features/messaging/domain/repositories/message_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../constants/constants.dart';
import '../../../../core/api/response.dart';
import '../../../../core/api/result_status.dart';
import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../../../core/error/error_manager.dart';
import '../../../shared/data/models/user.dart';
import '../models/conversation.dart';
import '../models/message.dart';

@LazySingleton(as: MessageRepository)
class MessageRepositoryImpl implements MessageRepository {
  final FirebaseFirestore _firestore;
  final ErrorManager _errorManager;

  MessageRepositoryImpl(
    @Named(firebaseFirestoreInstance) this._firestore,
    this._errorManager,
  );

  @override
  Future<Response<void>> sendMessage(
      String conversationId, Message message, List<User> participants) async {
    try {
      final conversationDoc = _firestore
          .collection(FirestoreConstants.conversationsCollection)
          .doc(conversationId);
      final conversationSnapshot = await conversationDoc.get();

      if (!conversationSnapshot.exists) {
        final newConversation = Conversation(
          id: conversationId,
          messages: [message],
          participantIds: participants.map((user) => user.id).toList(),
        );
        await conversationDoc.set(newConversation.toJson());
      } else {
        await conversationDoc.update({
          FirestoreConstants.messagesField:
              FieldValue.arrayUnion([message.toJson()])
        });
      }
      return Response(ResultStatus.success);
    } catch (e, s) {
      return _handleException('failed_to_send_message', e: e, s: s);
    }
  }

  @override
  Stream<List<Conversation>> getAllConversations(String? userId) {
    return _firestore
        .collection(FirestoreConstants.conversationsCollection)
        .where(FirestoreConstants.participantIdsField, arrayContains: userId)
        .snapshots()
        .handleError((e, s) =>
            _handleStreamException('failed_to_fetch_conversations', e: e, s: s))
        .asyncMap((snapshot) async {
      try {
        return Future.wait(snapshot.docs.map((doc) async {
          final data = doc.data();
          Conversation conversation = Conversation.fromJson(data);
          return conversation;
        }).toList());
      } catch (e, s) {
        throw Exception('failed_to_fetch_conversations'.tr());
      }
    });
  }

  @override
  Stream<Conversation> fetchConversation(String conversationId) {
    final conversationDoc = _firestore
        .collection(FirestoreConstants.conversationsCollection)
        .doc(conversationId);

    return conversationDoc.snapshots().asyncMap((snapshot) async {
      if (!snapshot.exists) {
        throw Exception('conversation_not_found'.tr());
      }

      try {
        final data = snapshot.data()!;
        Conversation conversation = Conversation.fromJson(data);
        return conversation;
      } catch (e, s) {
        throw Exception('failed_to_fetch_conversation'.tr());
      }
    }).handleError((e, s) =>
        _handleStreamException('failed_to_fetch_conversation', e: e, s: s));
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
