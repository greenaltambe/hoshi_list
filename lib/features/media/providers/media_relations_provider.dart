import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/services/anilist/anilist_client.dart';
import 'package:hoshi_list/services/anilist/mappers/media_relations_list_mapper.dart';

final anilistClient = AnilistClient();
final mediaRelationsMapper = MediaRelationsListMapper();

final relatedMediaProvider = FutureProvider.family((ref, int mediaId) async {
  final data = await anilistClient.fetchMediaRelationsList(mediaId);
  final decodedData = jsonDecode(data.body);
  return mediaRelationsMapper.mapMediaRelationsList(decodedData);
});
