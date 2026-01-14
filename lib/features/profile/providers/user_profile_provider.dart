import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/models/user.dart';
import 'package:hoshi_list/services/anilist/anilist_provider.dart';
import 'package:hoshi_list/services/anilist/mappers/user_details_mapper.dart';

final UserDetailsMapper userDetailsMapper = UserDetailsMapper();

final userProfileProvider = FutureProvider<User>((ref) async {
  final anilistClient = ref.watch(anilistProvider);

  final response = await anilistClient.fetchUserProfile();
  final decodedData = jsonDecode(response.body);
  return userDetailsMapper.fromJson(decodedData);
});
