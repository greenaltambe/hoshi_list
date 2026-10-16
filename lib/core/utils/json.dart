import 'package:hoshi_list/core/error/app_exception.dart';

typedef Json = Map<String, dynamic>;

/// Runs [parse] and converts the errors a malformed payload produces
/// (bad casts, missing keys...) into a [ParsingException].
T guardParse<T>(T Function() parse) {
  try {
    return parse();
  } on AppException {
    rethrow;
  } on TypeError {
    throw const ParsingException();
  } on NoSuchMethodError {
    throw const ParsingException();
  } on FormatException {
    throw const ParsingException();
  } on StateError {
    throw const ParsingException();
  }
}

/// AniList's `FuzzyDate` ({year, month, day}, any part nullable) as a
/// [DateTime]. Missing month/day default to 1; a missing year means no date.
DateTime? dateFromJson(Json? json) {
  final year = json?['year'] as int?;
  if (year == null) return null;
  return DateTime(year, json!['month'] as int? ?? 1, json['day'] as int? ?? 1);
}

/// `FuzzyDateInput`. Passing `null` produces the all-null object AniList
/// interprets as "clear this date".
Json dateToJson(DateTime? date) => {
  'year': date?.year,
  'month': date?.month,
  'day': date?.day,
};

/// `FuzzyDateInt`, e.g. 20240131.
int dateToFuzzyInt(DateTime date) =>
    date.year * 10000 + date.month * 100 + date.day;

String formatYmd(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';
