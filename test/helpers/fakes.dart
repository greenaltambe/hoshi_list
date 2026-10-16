import 'package:hoshi_list/core/auth/auth_repository.dart';

/// In-memory stand-in for [AuthRepository] (no platform channels).
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.token});

  String? token;

  @override
  Future<String?> readToken() async => token;

  @override
  Future<void> saveToken(String token) async => this.token = token;

  @override
  Future<void> clearToken() async => token = null;

  @override
  Future<void> openLogin() async {}

  @override
  Stream<String> redirectedTokens() => const Stream.empty();
}
