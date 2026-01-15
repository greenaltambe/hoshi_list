import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/models/media_mutation_query.dart';
import 'package:hoshi_list/services/anilist/anilist_provider.dart';
import 'package:hoshi_list/services/anilist/mappers/media_list_update_result_mapper.dart';

final mediaMutationQueryProvider = FutureProvider.family((
  ref,
  MediaMutationQuery mediaMutationQuery,
) async {
  final alClient = ref.watch(anilistProvider);

  final response = await alClient.saveMediaMutation(mediaMutationQuery);

  final decodedResponse = jsonDecode(response.body);
  final result = MediaListUpdateResultMapper().fromJson(decodedResponse);
  return result;
});
