import 'dart:convert';

import 'package:hoshi_list/models/media_list_query.dart';
import 'package:hoshi_list/services/anilist/queries/media_details_query_string.dart';
import 'package:hoshi_list/services/anilist/queries/media_list_query_string.dart';
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

      print('response: ${response.body}');

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
}
