class Conversation {
  final String id;
  final String user1Id;
  final String? user2Id;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;
  
  // User info untuk ditampilkan
  final String? otherUserName;
  final String? otherUserAvatar;
  final String? platform;

  const Conversation({
    required this.id,
    required this.user1Id,
    this.user2Id,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
    this.otherUserName,
    this.otherUserAvatar,
    this.platform,
  });
}
