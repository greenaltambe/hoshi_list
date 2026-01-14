import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/models/media.dart';
import 'package:hoshi_list/services/anilist/anilist_provider.dart';
import 'package:hoshi_list/services/anilist/mappers/media_details_mapper.dart';

final mediaDetailsMapper = MediaDetailsMapper();

final mediaDetailsProvider = FutureProvider.family<MediaDetails, int>((
  ref,
  mediaId,
) async {
  final alClient = ref.watch(anilistProvider);
  final response = await alClient.fetchMediaDetails(mediaId);
  final decodedBody = jsonDecode(response.body);
  final mediaDetails = mediaDetailsMapper.fromJson(decodedBody);
  return mediaDetails;
});
