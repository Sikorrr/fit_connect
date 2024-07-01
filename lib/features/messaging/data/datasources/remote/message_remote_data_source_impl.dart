import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../../constants/constants.dart';
import '../../../../../core/dependency_injection/dependency_injection.dart';
import '../../models/conversation.dart';
import '../../models/message.dart';
import 'message_remote_data_source.dart';

@LazySingleton(as: MessageRemoteDataSource)
class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final FirebaseFirestore _firestore;

  MessageRemoteDataSourceImpl(
      @Named(firebaseFirestoreInstance) this._firestore);

  @override
  Future<void> createConversation(
      String conversationId, Conversation conversation) async {
    final conversationDoc = _firestore
        .collection(FirestoreConstants.conversationsCollection)
        .doc(conversationId);
    await conversationDoc.set(conversation.toJson());
  }

  @override
  Future<void> updateConversationMessages(
      String conversationId, Message message) async {
    final conversationDoc = _firestore
        .collection(FirestoreConstants.conversationsCollection)
        .doc(conversationId);
    await conversationDoc.update({
      FirestoreConstants.messagesField:
          FieldValue.arrayUnion([message.toJson()])
    });
  }

  @override
  Future<bool> conversationExists(String conversationId) async {
    final conversationDoc = _firestore
        .collection(FirestoreConstants.conversationsCollection)
        .doc(conversationId);
    final conversationSnapshot = await conversationDoc.get();
    return conversationSnapshot.exists;
  }

  @override
  Stream<List<Conversation>> getAllConversations(String? userId) {
    return _firestore
        .collection(FirestoreConstants.conversationsCollection)
        .where(FirestoreConstants.participantIdsField, arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data()!;
              return Conversation.fromJson(data);
            }).toList());
  }

  @override
  Stream<Conversation> fetchConversation(String conversationId) {
    final conversationDoc = _firestore
        .collection(FirestoreConstants.conversationsCollection)
        .doc(conversationId);
    return conversationDoc.snapshots().map((snapshot) {
      if (!snapshot.exists) {
        throw Exception('conversation_not_found');
      }
      final data = snapshot.data()!;
      return Conversation.fromJson(data);
    });
  }
}
