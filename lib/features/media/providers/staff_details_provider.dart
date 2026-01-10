import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/models/staff.dart';
import 'package:hoshi_list/services/anilist/anilist_client.dart';
import 'package:hoshi_list/services/anilist/mappers/media_staff_mapper.dart';

final alClient = AnilistClient();
final mediaStaffMapper = MediaStaffMapper();

final mediaStaffDetailsProvider = FutureProvider.family<MediaStaff, int>((
  ref,
  mediaStaffId,
) async {
  final response = await alClient.fetchMediaStaffDetails(mediaStaffId);
  final decodedBody = jsonDecode(response.body);
  final mediaStaff = mediaStaffMapper.toStaff(decodedBody);
  return mediaStaff;
});
