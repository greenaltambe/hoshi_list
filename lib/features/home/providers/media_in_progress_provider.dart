import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/data/dummy_anime.dart';
import 'package:hoshi_list/models/media.dart';

final mediaInProgressProvider = Provider<List<Media>>((ref) {
  return dummyAnimeList;
});
