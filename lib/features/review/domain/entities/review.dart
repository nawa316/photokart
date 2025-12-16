class Review {
  final String id;
  final String userId;
  final String productId;
  final int stars;
  final String text;
  final DateTime created;
  final String? username;
  final String? userAvatar;

  Review({
    required this.id,
    required this.userId,
    required this.productId,
    required this.stars,
    required this.text,
    required this.created,
    this.username,
    this.userAvatar,
  });

  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(created);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
