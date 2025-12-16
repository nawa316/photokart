class Message {
  final String id;
  final String text;
  final String? photoUrl;
  final DateTime sent;
  final String userId;
  final String convoId;
  final bool isSentByMe;
  final bool isRead;

  const Message({
    required this.id,
    required this.text,
    this.photoUrl,
    required this.sent,
    required this.userId,
    required this.convoId,
    this.isSentByMe = false,
    this.isRead = false,
  });
}
