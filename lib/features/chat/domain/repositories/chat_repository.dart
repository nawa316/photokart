import '../entities/conversation.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  /// Get all conversations for the current user
  Future<List<Conversation>> getConversations();
  
  /// Get a specific conversation by ID
  Future<Conversation> getConversationById(String conversationId);
  
  /// Get all messages in a conversation
  Future<List<Message>> getMessages(String conversationId);
  
  /// Send a new message
  Future<Message> sendMessage({
    required String conversationId,
    required String text,
    String? photoUrl,
  });
  
  /// Create a new conversation
  Future<Conversation> createConversation({
    required String user1Id,
    required String user2Id,
  });
  
  /// Mark messages as read
  Future<void> markAsRead(String conversationId);
  
  /// Delete a conversation
  Future<void> deleteConversation(String conversationId);
}
