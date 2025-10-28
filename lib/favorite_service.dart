import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  // Generate a key per user
  static String _keyForUser(String userId) => 'favorite_movies_$userId';

  static Future<List<FavoriteMovie>> loadFavorites(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyForUser(userId)) ?? [];
    return list.map((s) => FavoriteMovie.fromJson(jsonDecode(s))).toList();
  }

  static Future<void> saveFavorites(String userId, List<FavoriteMovie> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final list = favorites.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList(_keyForUser(userId), list);
  }

  static Future<void> addFavorite(String userId, FavoriteMovie m) async {
    final favorites = await loadFavorites(userId);
    if (!favorites.any((f) => f.id == m.id)) {
      favorites.add(m);
      await saveFavorites(userId, favorites);
    }
  }

  static Future<void> removeFavorite(String userId, int id) async {
    final favorites = await loadFavorites(userId);
    favorites.removeWhere((f) => f.id == id);
    await saveFavorites(userId, favorites);
  }
}

class FavoriteMovie {
  final int id;
  final String title;
  final String? posterPath;

  FavoriteMovie({required this.id, required this.title, this.posterPath});

  factory FavoriteMovie.fromJson(Map<String, dynamic> json) {
    return FavoriteMovie(
      id: json['id'],
      title: json['title'],
      posterPath: json['posterPath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
    };
  }

  String get posterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : '';
}
