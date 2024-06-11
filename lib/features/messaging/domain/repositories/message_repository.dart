import '../../../../core/api/response.dart';
import '../../../shared/data/models/user.dart';
import '../../data/models/conversation.dart';
import '../../data/models/message.dart';

abstract class MessageRepository {
  Future<Response<void>> sendMessage(
      String conversationId, Message message, List<User> participants);

  Stream<List<Conversation>> getAllConversations(String? userId);

  Stream<Conversation> fetchConversation(String conversationId);
}
