import 'package:flutter/material.dart';

class UserModel {
  final int userId;
  final String email;
  final String username;
  final String password;
  final String gender;
  final List<String> genres;

  UserModel({
    required this.userId,
    required this.email,
    required this.username,
    required this.password,
    required this.gender,
    required this.genres,
  });
}

class UserProvider with ChangeNotifier {
  final List<UserModel> _users = [];

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

   UserProvider() {
    _currentUser = UserModel(
      userId: 0,
      email: 'dummy@dev.com',
      username: 'devUser',
      password: '123456',
      gender: 'Male',
      genres: ['Action', 'Drama', 'Thriller'],
    );

    _users.add(_currentUser!);
  }

  void addUser({
    required String email,
    required String username,
    required String password,
    required String gender,
    required List<String> genres,
  }) {
    final newUser = UserModel(
      userId: _users.length+1,
      email: email,
      username: username,
      password: password,
      gender: gender,
      genres: genres,
    );
    _users.add(newUser);
    notifyListeners();
  }
  

  UserModel? getUserLogin(String email) {
    try {
      final user = _users.firstWhere((u) => u.email == email);
      _currentUser = user;
      return user;
    } catch (e) {
      return null;
    }
  }

  void updateUser(String email, String gender, List<String> genres) {
    final index = _users.indexWhere((u) => u.email == email);
    if (index != -1) {
      final old = _users[index];
      _currentUser = UserModel(
        userId: old.userId,
        email: old.email,
        username: old.username,
        password: old.password,
        gender: gender,
        genres: genres,
      );
      notifyListeners();
    }
  }

  void userLogout(){
    _currentUser = null;
    notifyListeners();
  }

  List<UserModel> get allUsers => [..._users];
}