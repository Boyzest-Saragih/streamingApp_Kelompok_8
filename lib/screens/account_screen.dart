import 'package:flutter/material.dart';
import 'package:flutter_fe/provider/language.dart';
import 'package:flutter_fe/provider/theme.dart';
import 'package:flutter_fe/provider/user.dart';
import 'package:flutter_fe/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fe/screens/register_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<User>(context);
    final themeProvider = Provider.of<ThemeProv>(context);
    final user = userProvider.currentUser;
    final theme = themeProvider.isDarkMode;

    // if (user.isEmpty) {
    //   return const Scaffold(
    //     backgroundColor: Color(0xFF06141B),
    //     body: Center(
    //       child: Text(
    //         "Tidak Ada Data User",
    //         style: TextStyle(color: Colors.white),
    //       ),
    //     ),
    //   );
    // }

    final data = user[1];

    final languageProvider = Provider.of<LanguageProv>(context);
    final enLang = languageProvider.currentLanguage == "en" ? true : false;

    return Scaffold(
      appBar: AppBar(
        title: Text(enLang ? "Account Info" : "Info Akun"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20,2,20,2),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: theme ? Colors.amber : Colors.grey,
                  child: Text(
                    data[1][0].toString().toUpperCase(),
                    style: TextStyle(
                      color: theme ? Colors.black : Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildItem(Icons.email, "Email", data[0]),
              _buildItem(
                Icons.person,
                enLang ? "Username" : "Nama pengguna",
                data[1],
              ),
              _buildItem(
                Icons.lock,
                enLang ? "Password" : "Kata sandi",
                "********",
              ),
              _buildItem(
                Icons.wc,
                enLang ? "Gender" : "Jenis Kelamin",
                data[3],
              ),
              _buildItem(
                Icons.movie_filter,
                enLang ? "Fav Genres" : "Genre Favorit",
                data[4] is List
                    ? (data[4] as List).join(", ")
                    : data[4].toString(),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    userProvider.currentUser = [];
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.logout),
                  label: Text(
                    enLang ? "Logout" : "Keluar",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String title, String subtitle) {
    return Card(
      color: const Color(0xFF11212D),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.amber),
        title: Text(title, style: const TextStyle(color: Colors.grey)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
