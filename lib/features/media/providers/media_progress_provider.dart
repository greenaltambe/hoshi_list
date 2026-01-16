import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/models/media_tracking_status.dart';
import 'package:hoshi_list/services/anilist/anilist_provider.dart';
import 'package:hoshi_list/services/anilist/mappers/media_tracking_status_mapper.dart';

final mediaProgressProvider = FutureProvider.family<MediaTrackingStatus, int>((
  ref,
  mediaId,
) async {
  final alClient = ref.watch(anilistProvider);
  final response = await alClient.fetchMediaProgress(mediaId);
  final decodedBody = jsonDecode(response.body);
  return MediaTrackingStatusMapper().fromJson(decodedBody);
});
