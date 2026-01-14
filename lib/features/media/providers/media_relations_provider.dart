import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/services/anilist/anilist_provider.dart';
import 'package:hoshi_list/services/anilist/mappers/media_relations_list_mapper.dart';

final mediaRelationsMapper = MediaRelationsListMapper();

final relatedMediaProvider = FutureProvider.family((ref, int mediaId) async {
  final alClient = ref.watch(anilistProvider);
  final data = await alClient.fetchMediaRelationsList(mediaId);
  final decodedData = jsonDecode(data.body);
  return mediaRelationsMapper.mapMediaRelationsList(decodedData);
});
