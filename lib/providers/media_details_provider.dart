import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/data/dummy_anime_details.dart';
import 'package:hoshi_list/model/media.dart';

final mediaDetailsProvider = Provider.family<MediaDetails, int>((ref, mediaId) {
  final mediaDetails = dummyMediaDetails[mediaId];
  if (mediaDetails == null) {
    throw Exception('Media details not found for id: $mediaId');
  }
  return mediaDetails;
});
