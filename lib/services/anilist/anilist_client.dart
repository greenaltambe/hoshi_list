import 'dart:convert';

import 'package:hoshi_list/services/anilist/queries/trending.dart';
import 'package:http/http.dart' as http;

class AnilistClient {
  String baseUrl = "https://graphql.anilist.co";

  Future<http.Response> _performQuery(String query) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"query": query}),
      );

      return response;
    } catch (e) {
      throw Exception('Failed to perform query: $e');
    }
  }

  Future<http.Response> fetchTrendingAnime() async {
    final query = trendingAnimeQuery;
    return await _performQuery(query);
  }

  Future<http.Response> fetchTrendingManga() async {
    final query = trendingMangaQuery;
    return await _performQuery(query);
  }
}
