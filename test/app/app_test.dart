import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hoshi_list/app/app.dart';
import 'package:hoshi_list/core/auth/auth_controller.dart';
import 'package:hoshi_list/core/auth/auth_repository.dart';

import '../helpers/fakes.dart';

void main() {
  testWidgets('logged-out users see the login screen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Login with AniList'), findsOneWidget);
  });

  test('logging out clears the stored token', () async {
    final repository = FakeAuthRepository(token: 'abc');
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    expect(await container.read(authControllerProvider.future), 'abc');

    await container.read(authControllerProvider.notifier).logout();

    expect(container.read(authControllerProvider).value, isNull);
    expect(repository.token, isNull);
  });
}
