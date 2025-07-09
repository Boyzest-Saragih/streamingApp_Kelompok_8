import 'package:flutter/material.dart';

class User {
  final int userId;

  User({required this.userId});
}

class Movie {
  final String movieId;
  final String title;
  final String desc;
  final String posterPath;

  Movie({
    required this.movieId,
    required this.title,
    required this.desc,
    required this.posterPath,
  });
}

class FavoriteMoviesProvider with ChangeNotifier {
  final Map<String, List<Movie>> _userFavorites = {};

  List<dynamic> getFavorites(String userId) {
    print(_userFavorites[userId] ?? []);
    return _userFavorites[userId] ?? [];
  }

  void addFavorite(String userId, movie) {
    _userFavorites.putIfAbsent(userId, () => []);
    if (!_userFavorites[userId]!.any((m) => m.movieId == movie.movieId)) {
      _userFavorites[userId]!.add(movie);
      notifyListeners();
    }
  }

  void removeFavorite(String userId, movie) {
    _userFavorites[userId]?.removeWhere((m) => m.movieId == movie.movieId);
    notifyListeners();
  }

  bool isFavorite(String userId, movieId) {
    return _userFavorites[userId]?.any((m) => m.movieId == movieId) ?? false;
  }
}
