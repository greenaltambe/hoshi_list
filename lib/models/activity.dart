enum ActivityType { watched, read, status }

class Activity {
  final String id;

  // User
  final String username;
  final bool isDonator;

  // Type of activity
  final ActivityType type;

  // Media-related (nullable for status posts)
  final String? mediaTitle;
  final int? start;
  final int? end;
  final String? imageUrl;

  // Status post (nullable for media activity)
  final String? statusText;

  // Meta
  final DateTime createdAt;

  // Engagement
  final int likes;
  final int comments;

  Activity({
    required this.id,
    required this.username,
    required this.isDonator,
    required this.type,
    this.mediaTitle,
    this.imageUrl,
    this.start,
    this.end,
    this.statusText,
    required this.createdAt,
    required this.likes,
    required this.comments,
  });
}
