import 'package:hoshi_list/core/utils/api_enum.dart';
import 'package:hoshi_list/features/profile/domain/user.dart';

class MediaReview {
  const MediaReview({
    required this.id,
    required this.summary,
    required this.author,
    required this.score,
    required this.rating,
    this.body,
  });

  final int id;
  final String summary;
  final User author;
  final int score;
  final int rating;
  final String? body;
}

enum ReviewSort implements ApiEnum {
  ratingDesc('RATING_DESC'),
  scoreDesc('SCORE_DESC'),
  updatedAtDesc('UPDATED_AT_DESC'),
  createdAtDesc('CREATED_AT_DESC');

  const ReviewSort(this.apiValue);

  @override
  final String apiValue;
}
