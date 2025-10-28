import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simple_authentication/model/movie.dart';

class TmdbService {
  static const String _apiKey = '03e03631ee09c5a26f6c8c883e3bfa5b';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  final http.Client _client;
  TmdbService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    if (query.trim().isEmpty) return [];
    final uri = Uri.parse('$_baseUrl/search/movie').replace(
      queryParameters: {
        'api_key': _apiKey,
        'query': query,
        'page': page.toString(),
        'include_adult': 'false',
        'language': 'en-US',
      },
    );

    final resp = await _client.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('TMDB search failed: ${resp.statusCode}');
    }
    final data = json.decode(resp.body) as Map<String, dynamic>;
    final results = (data['results'] as List<dynamic>?) ?? [];
    return results
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Movie> getMovieDetails(int movieId) async {
    final uri = Uri.parse(
      '$_baseUrl/movie/$movieId',
    ).replace(queryParameters: {'api_key': _apiKey, 'language': 'en-US'});

    final resp = await _client.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('TMDB movie details failed: ${resp.statusCode}');
    }
    final data = json.decode(resp.body) as Map<String, dynamic>;
    return Movie.fromJson(data);
  }

  void dispose() {
    _client.close();
  }
}
