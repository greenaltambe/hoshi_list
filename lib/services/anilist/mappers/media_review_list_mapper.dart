import 'package:hoshi_list/models/review.dart';
import 'package:hoshi_list/models/user.dart';

class MediaReviewListMapper {
  const MediaReviewListMapper();

  List<MediaReview> toMediaReviewList(Map<String, dynamic> json) {
    if (json['errors'] != null) {
      throw Exception('Error from Anilist API: ${json['errors']}');
    }

    if (json['data'] == null ||
        json['data']['Media'] == null ||
        json['data']['Media']['reviews'] == null ||
        json['data']['Media']['reviews']['nodes'] == null) {
      throw Exception('Invalid data format from Anilist API');
    }

    final reviewsJson =
        json['data']['Media']['reviews']['nodes'] as List<dynamic>;

    return reviewsJson.map((reviewJson) {
      final id = reviewJson['id'] as int;
      final userJson = reviewJson['user'];
      final userId = userJson['id'] as int;
      final userName = userJson['name'] as String;
      final userAvatarUrl = userJson['avatar']['medium'] as String;
      final summary = reviewJson['summary'] as String? ?? '';
      final score = reviewJson['score'] as int? ?? 0;
      final rating = reviewJson['rating'] as int? ?? 0;
      final body = reviewJson['body'] as String?;

      return MediaReview(
        id: id,
        author: User(id: userId, name: userName, avatarUrl: userAvatarUrl),
        summary: summary,
        score: score,
        body: body,
        rating: rating,
      );
    }).toList();
  }
}
