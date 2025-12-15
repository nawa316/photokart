import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.text,
    super.photoUrl,
    required super.sent,
    required super.userId,
    required super.convoId,
    super.isSentByMe,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json, {String? currentUserId}) {
    final userId = json['userId'] as String;
    return MessageModel(
      id: json['id'] as String,
      text: json['text'] as String,
      photoUrl: json['photoUrl'] as String?,
      sent: DateTime.parse(json['sent'] as String),
      userId: userId,
      convoId: json['convoId'] as String,
      isSentByMe: currentUserId != null && userId == currentUserId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'photoUrl': photoUrl,
      'sent': sent.toIso8601String(),
      'userId': userId,
      'convoId': convoId,
    };
  }

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      text: message.text,
      photoUrl: message.photoUrl,
      sent: message.sent,
      userId: message.userId,
      convoId: message.convoId,
      isSentByMe: message.isSentByMe,
    );
  }
}
