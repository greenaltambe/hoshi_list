import 'package:hoshi_list/models/user.dart';

class MediaReview {
  final int id;
  final String summary;
  final int score;

  final User author;
  final int rating;

  final String? body;

  const MediaReview({
    required this.id,
    required this.summary,
    required this.author,
    required this.score,
    required this.rating,
    this.body,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MediaReview &&
            other.id == id &&
            other.summary == summary &&
            other.author == author &&
            other.score == score &&
            other.rating == rating &&
            other.body == body;
  }

  @override
  int get hashCode => Object.hash(id, summary, author, score, rating, body);
}

enum MediaReviewSort {
  rating,
  ratingDesc,
  score,
  scoreDesc,
  updatedAt,
  updatedAtDesc,
  createdAt,
  createdAtDesc,
}

class MediaReviewQueryAL {
  final int mediaId;
  final int page;
  final int perPage;
  final List<MediaReviewSort> sort;

  const MediaReviewQueryAL({
    required this.mediaId,
    required this.page,
    required this.perPage,
    this.sort = const [MediaReviewSort.ratingDesc],
  });
}
