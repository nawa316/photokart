import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Conversation>> getConversations() async {
    try {
      return await remoteDataSource.getConversations();
    } catch (e) {
      throw Exception('Failed to get conversations: $e');
    }
  }

  @override
  Future<Conversation> getConversationById(String conversationId) async {
    try {
      return await remoteDataSource.getConversationById(conversationId);
    } catch (e) {
      throw Exception('Failed to get conversation: $e');
    }
  }

  @override
  Future<List<Message>> getMessages(String conversationId) async {
    try {
      return await remoteDataSource.getMessages(conversationId);
    } catch (e) {
      throw Exception('Failed to get messages: $e');
    }
  }

  @override
  Future<Message> sendMessage({
    required String conversationId,
    required String text,
    String? photoUrl,
  }) async {
    try {
      return await remoteDataSource.sendMessage(
        conversationId: conversationId,
        text: text,
        photoUrl: photoUrl,
      );
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Future<Conversation> createConversation({
    required String user1Id,
    required String user2Id,
  }) async {
    try {
      return await remoteDataSource.createConversation(
        user1Id: user1Id,
        user2Id: user2Id,
      );
    } catch (e) {
      throw Exception('Failed to create conversation: $e');
    }
  }

  @override
  Future<void> markAsRead(String conversationId) async {
    try {
      await remoteDataSource.markAsRead(conversationId);
    } catch (e) {
      throw Exception('Failed to mark as read: $e');
    }
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    try {
      await remoteDataSource.deleteConversation(conversationId);
    } catch (e) {
      throw Exception('Failed to delete conversation: $e');
    }
  }
}
