import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/data/dummy_profile_data.dart';
import 'package:hoshi_list/models/profile.dart';

final userProfileProvider = Provider<UserProfile>((ref) {
  return dummyUserProfile;
});
