import '../../models/conversation.dart';
import '../../models/message.dart';

abstract class MessageRemoteDataSource {
  Future<void> createConversation(
      String conversationId, Conversation conversation);
  Future<void> updateConversationMessages(
      String conversationId, Message message);
  Future<bool> conversationExists(String conversationId);
  Stream<List<Conversation>> getAllConversations(String? userId);
  Stream<Conversation> fetchConversation(String conversationId);
}
