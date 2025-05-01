import 'package:flutter/material.dart';

class User with ChangeNotifier {
  List<List<dynamic>> usersData = [
    [1, ["sdd", "qqq", 123, "Male", ["Family", "Disaster", "Psychological"]]],
  ];

  List<dynamic> currentUser = [1, ["sdd", "qqq", 123, "Male", ["Family", "Disaster", "Psychological"]]];

  void addUser(email, username, password) {
    usersData.add([email, username, password]);
  }

  void getUserLogin(email) {
    final user = usersData.firstWhere((user) => user[0] == email);
    final userIdx = usersData.indexWhere((user) => user[0] == email);
    currentUser = [userIdx,user];
    print(currentUser);
  }

  void addUserData(userIdx, jenisKelamin,genres) {
    usersData[userIdx].addAll([jenisKelamin,genres]);
  }
}
