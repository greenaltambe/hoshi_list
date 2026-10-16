/// Errors the UI can reason about. Repositories and the network client throw
/// these instead of leaking `http` / `TypeError` details upwards.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

final class NetworkException extends AppException {
  const NetworkException([
    super.message = 'Could not reach AniList. Check your connection.',
  ]);
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'Your session has expired. Please log in again.',
  ]);
}

final class ApiException extends AppException {
  const ApiException(super.message, {this.statusCode});

  final int? statusCode;
}

final class ParsingException extends AppException {
  const ParsingException([
    super.message = 'AniList returned data in an unexpected format.',
  ]);
}

/// A message that is safe to show to the user for any thrown object.
String describeError(Object error) {
  if (error is AppException) return error.message;
  return 'Something went wrong. Please try again.';
}
