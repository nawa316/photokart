import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ConversationModel>> getConversations();
  Future<ConversationModel> getConversationById(String conversationId);
  Future<List<MessageModel>> getMessages(String conversationId);
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String text,
    String? photoUrl,
  });
  Future<ConversationModel> createConversation({
    required String user1Id,
    required String user2Id,
  });
  Future<void> markAsRead(String conversationId);
  Future<void> deleteConversation(String conversationId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SupabaseClient supabaseClient;

  ChatRemoteDataSourceImpl({required this.supabaseClient});

  String? get _currentUserId => supabaseClient.auth.currentUser?.id;

  @override
  Future<List<ConversationModel>> getConversations() async {
    try {
      final userId = _currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      // Get conversations where user is either user1 or user2
      final response = await supabaseClient
          .from('conversation')
          .select('id, user1Id, user2Id')
          .or('user1Id.eq.$userId,user2Id.eq.$userId') as List<dynamic>;

      // Transform response to include user info and last message
      final List<ConversationModel> conversations = [];
      
      for (var convo in response) {
        final convoMap = convo as Map<String, dynamic>;
        
        // Get the other user's ID
        final otherUserId = convoMap['user1Id'] == userId 
            ? convoMap['user2Id'] 
            : convoMap['user1Id'];

        if (otherUserId == null) continue;

        // Get other user's info
        final userInfo = await supabaseClient
            .from('users')
            .select('username, avatarUrl')
            .eq('id', otherUserId)
            .maybeSingle();

        if (userInfo == null) continue;

        // Get last message
        final messagesResponse = await supabaseClient
            .from('message')
            .select('text, sent, userId')
            .eq('convoId', convoMap['id'])
            .order('sent', ascending: false)
            .limit(1) as List<dynamic>;

        final lastMessage = messagesResponse.isNotEmpty 
            ? messagesResponse.first as Map<String, dynamic>
            : null;

        // Get unread count - messages from other user that haven't been read
        final unreadMessages = await supabaseClient
            .from('message')
            .select('id')
            .eq('convoId', convoMap['id'])
            .neq('userId', userId)
            .eq('isRead', false) as List<dynamic>;

        final unreadCount = unreadMessages.length;

        conversations.add(ConversationModel(
          id: convoMap['id'] as String,
          user1Id: convoMap['user1Id'] as String,
          user2Id: convoMap['user2Id'] as String?,
          lastMessage: lastMessage?['text'] as String?,
          lastMessageTime: lastMessage != null 
              ? DateTime.parse(lastMessage['sent'] as String)
              : null,
          unreadCount: unreadCount,
          otherUserName: userInfo['username'] as String?,
          otherUserAvatar: userInfo['avatarUrl'] as String?,
        ));
      }

      return conversations;
    } catch (e) {
      throw Exception('Failed to load conversations: $e');
    }
  }

  @override
  Future<ConversationModel> getConversationById(String conversationId) async {
    try {
      final response = await supabaseClient
          .from('conversation')
          .select()
          .eq('id', conversationId)
          .single();

      return ConversationModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load conversation: $e');
    }
  }

  @override
  Future<List<MessageModel>> getMessages(String conversationId) async {
    try {
      final userId = _currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      final response = await supabaseClient
          .from('message')
          .select()
          .eq('convoId', conversationId)
          .order('sent', ascending: true) as List<dynamic>;

      return response
          .map((json) => MessageModel.fromJson(json as Map<String, dynamic>, currentUserId: userId))
          .toList();
    } catch (e) {
      throw Exception('Failed to load messages: $e');
    }
  }

  @override
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String text,
    String? photoUrl,
  }) async {
    try {
      final userId = _currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      // Generate UUID for message
      const uuid = Uuid();
      final messageId = uuid.v4();

      final messageData = {
        'id': messageId,
        'text': text,
        'photoUrl': photoUrl,
        'sent': DateTime.now().toIso8601String(),
        'userId': userId,
        'convoId': conversationId,
        'isRead': false,
      };

      final response = await supabaseClient
          .from('message')
          .insert(messageData)
          .select()
          .single();

      return MessageModel.fromJson(response, currentUserId: userId);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Future<ConversationModel> createConversation({
    required String user1Id,
    required String user2Id,
  }) async {
    try {
      final conversationData = {
        'user1Id': user1Id,
        'user2Id': user2Id,
      };

      final response = await supabaseClient
          .from('conversation')
          .insert(conversationData)
          .select()
          .single();

      return ConversationModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create conversation: $e');
    }
  }

  @override
  Future<void> markAsRead(String conversationId) async {
    try {
      final userId = _currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      // Mark all messages in this conversation from other users as read
      await supabaseClient
          .from('message')
          .update({'isRead': true})
          .eq('convoId', conversationId)
          .neq('userId', userId)
          .eq('isRead', false);
    } catch (e) {
      throw Exception('Failed to mark as read: $e');
    }
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    try {
      // First delete all messages
      await supabaseClient
          .from('message')
          .delete()
          .eq('convoId', conversationId);

      // Then delete the conversation
      await supabaseClient
          .from('conversation')
          .delete()
          .eq('id', conversationId);
    } catch (e) {
      throw Exception('Failed to delete conversation: $e');
    }
  }
}
