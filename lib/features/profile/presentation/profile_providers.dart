import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/core/auth/auth_controller.dart';
import 'package:hoshi_list/features/profile/data/profile_repository.dart';
import 'package:hoshi_list/features/profile/domain/user.dart';

/// The logged-in user, or null when logged out. Re-runs on login/logout so
/// nothing user-specific can outlive a session.
final currentUserProvider = FutureProvider<User?>((ref) async {
  final token = await ref.watch(authControllerProvider.future);
  if (token == null) return null;
  return ref.watch(profileRepositoryProvider).viewer();
});
