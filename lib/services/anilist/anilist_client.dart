import 'dart:convert';

import 'package:hoshi_list/models/media_character.dart';
import 'package:hoshi_list/models/media_list_query.dart';
import 'package:hoshi_list/models/review.dart';
import 'package:hoshi_list/models/staff.dart';
import 'package:hoshi_list/services/anilist/queries/character_details_query_string.dart';
import 'package:hoshi_list/services/anilist/queries/characters_list_query_string.dart';
import 'package:hoshi_list/services/anilist/queries/media_details_query_string.dart';
import 'package:hoshi_list/services/anilist/queries/media_list_query_string.dart';
import 'package:hoshi_list/services/anilist/queries/media_review_list_query_string.dart';
import 'package:hoshi_list/services/anilist/queries/staff_details_query_string.dart';
import 'package:hoshi_list/services/anilist/queries/staff_list_query_string.dart';
import 'package:http/http.dart' as http;

class AnilistClient {
  String baseUrl = "https://graphql.anilist.co";

  Future<http.Response> _performQuery(
    String query,
    Map<String, dynamic> variables,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"query": query, "variables": variables}),
      );

      print(response.body);

      return response;
    } catch (e) {
      throw Exception('Failed to perform query: $e');
    }
  }

  // Helper to build query variables from MediaQueryAL
  Map<String, dynamic> _queryVariableBuilder(MediaQueryAL mediaQuery) {
    final variables = {
      "page": mediaQuery.page.toInt(),
      "perPage": mediaQuery.perPage.toInt(),
      "type": mediaQuery.type.name.toUpperCase(),
      "sort": !mediaQuery.sort.name.toLowerCase().contains('desc')
          ? mediaQuery.sort.name.toUpperCase()
          : mediaQuery.sort.name.toUpperCase().replaceAll('DESC', '_DESC'),
    };

    return variables;
  }

  // The public method to fetch media based on MediaQueryAL
  Future<http.Response> fetchMedia(MediaQueryAL mediaQuery) async {
    final variables = _queryVariableBuilder(mediaQuery);
    return _performQuery(mediaQueryString, variables);
  }

  Future<http.Response> fetchMediaDetails(int mediaId) async {
    final variables = {"id": mediaId};
    return _performQuery(mediaDetailsQueryString, variables);
  }

  // Additional methods for other queries can be added here
  Future<http.Response> fetchMediaCharacters(
    MediaCharacterQueryAL mediaCharacterQuery,
  ) async {
    final variables = {
      "mediaId": mediaCharacterQuery.mediaId,
      "page": mediaCharacterQuery.page,
      "perPage": mediaCharacterQuery.perPage,
      "sort": mediaCharacterQuery.sort
          .map((e) => e.name.toUpperCase().replaceAll('DESC', '_DESC'))
          .toList(),
    };

    return _performQuery(charactersListQueryString, variables);
  }

  // Method that fetches media character details
  Future<http.Response> fetchMediaCharacterDetails(int mediaCharacterId) async {
    final variables = {"id": mediaCharacterId};
    return _performQuery(mediaCharacterDetailsQueryString, variables);
  }

  // Method that fetches media staff list
  Future<http.Response> fetchMediaStaff(
    MediaStaffQueryAL mediaStaffQuery,
  ) async {
    final variables = {
      "mediaId": mediaStaffQuery.mediaId,
      "page": mediaStaffQuery.page,
      "perPage": mediaStaffQuery.perPage,
      "sort": mediaStaffQuery.sort
          .map((e) => e.name.toUpperCase().replaceAll('DESC', '_DESC'))
          .toList(),
    };

    return _performQuery(staffListQueryString, variables);
  }

  // Method that fetches staff details
  Future<http.Response> fetchMediaStaffDetails(int staffId) async {
    final variables = {"id": staffId};
    return _performQuery(staffDetailsQueryString, variables);
  }

  // Method that fetches media review list
  Future<http.Response> fetchMediaReviewList(
    MediaReviewQueryAL mediaReviewQuery,
  ) async {
    final variables = {
      "mediaId": mediaReviewQuery.mediaId,
      "page": mediaReviewQuery.page,
      "perPage": mediaReviewQuery.perPage,
      "sort": mediaReviewQuery.sort
          .map((e) => e.name.toUpperCase().replaceAll('DESC', '_DESC'))
          .toList(),
    };
    return _performQuery(mediaReviewListQueryString, variables);
  }
}
