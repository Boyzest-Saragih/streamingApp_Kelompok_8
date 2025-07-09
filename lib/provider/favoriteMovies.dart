import 'package:flutter/material.dart';

class User{
  final int userId;

  User({required this.userId});
}

class Movie{
  final String movieId;

  Movie({required this.movieId});
}


class FavoriteMoviesProvider with ChangeNotifier {
  final Map<String, List<Movie>> _userFavorites = {};

  List<Movie> getFavorites(String userId) {
    print(_userFavorites[userId] ?? []);
    return _userFavorites[userId] ?? [];
  }

  void addFavorite(String userId, Movie movie) {
    _userFavorites.putIfAbsent(userId, () => []);
    if (!_userFavorites[userId]!.any((m) => m.movieId == movie.movieId)) {
      _userFavorites[userId]!.add(movie);
      notifyListeners();
    }
  }

  void removeFavorite(String userId, Movie movie) {
    _userFavorites[userId]?.removeWhere((m) => m.movieId == movie.movieId);
    notifyListeners();
  }

  bool isFavorite(String userId, String movieId) {
    return _userFavorites[userId]?.any((m) => m.movieId == movieId) ?? false;
  }
}
