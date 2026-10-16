/// An enum that maps to a value of an AniList GraphQL enum.
abstract interface class ApiEnum {
  String get apiValue;
}

/// Finds the entry of [values] whose [ApiEnum.apiValue] is [raw].
T? parseApiEnum<T extends ApiEnum>(List<T> values, String? raw) {
  for (final value in values) {
    if (value.apiValue == raw) return value;
  }
  return null;
}
