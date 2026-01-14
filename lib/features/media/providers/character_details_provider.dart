import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/models/media_character.dart';
import 'package:hoshi_list/services/anilist/anilist_provider.dart';
import 'package:hoshi_list/services/anilist/mappers/media_character_mapper.dart';

final mediaCharacterMapper = MediaCharacterMapper();

final mediaCharacterDetailsProvider =
    FutureProvider.family<MediaCharacter, int>((ref, mediaCharacterId) async {
      final alClient = ref.watch(anilistProvider);
      final response = await alClient.fetchMediaCharacterDetails(
        mediaCharacterId,
      );

      final decodedBody = jsonDecode(response.body);
      final mediaCharacter = mediaCharacterMapper.toMediaCharacter(decodedBody);
      return mediaCharacter;
    });
