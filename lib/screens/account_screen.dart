import 'package:flutter/material.dart';
import 'package:flutter_fe/provider/language.dart';
import 'package:flutter_fe/provider/theme.dart';
import 'package:flutter_fe/provider/user.dart';
import 'package:flutter_fe/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fe/screens/register_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  static const List<Map<String, String>> movieGenres = [
    {'en': 'Action', 'in': 'Aksi'},
    {'en': 'Adventure', 'in': 'Petualangan'},
    {'en': 'Animation', 'in': 'Animasi'},
    {'en': 'Comedy', 'in': 'Komedi'},
    {'en': 'Crime', 'in': 'Kriminal'},
    {'en': 'Documentary', 'in': 'Dokumenter'},
    {'en': 'Drama', 'in': 'Drama'},
    {'en': 'Fantasy', 'in': 'Fantasi'},
    {'en': 'Historical', 'in': 'Sejarah'},
    {'en': 'Horror', 'in': 'Horor'},
    {'en': 'Musical', 'in': 'Musikal'},
    {'en': 'Mystery', 'in': 'Misteri'},
    {'en': 'Romance', 'in': 'Romansa'},
    {'en': 'Science Fiction', 'in': 'Fiksi Ilmiah'},
    {'en': 'Thriller', 'in': 'Thriller'},
    {'en': 'Western', 'in': 'Barat'},
    {'en': 'War', 'in': 'Perang'},
    {'en': 'Biography', 'in': 'Biografi'},
    {'en': 'Family', 'in': 'Keluarga'},
    {'en': 'Sports', 'in': 'Olahraga'},
    {'en': 'Superhero', 'in': 'Pahlawan Super'},
    {'en': 'Noir', 'in': 'Noir'},
    {'en': 'Psychological', 'in': 'Psikologis'},
    {'en': 'Disaster', 'in': 'Bencana'},
  ];

  static const Map<String, String> genderMap = {
    'Male': 'Laki-laki',
    'Female': 'Perempuan',
  };

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProv>(context);
    final user = userProvider.currentUser;
    final theme = themeProvider.isDarkMode;
    final languageProvider = Provider.of<LanguageProv>(context);
    final enLang = languageProvider.currentLanguage == "en";

    print('AccountScreen - Current language: ${languageProvider.currentLanguage}');
    print('AccountScreen - enLang: $enLang');
    print('AccountScreen - Gender: ${user?.gender}');
    print('AccountScreen - Genres: ${user?.genres}');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: theme ? Colors.amber : Colors.grey,
                  backgroundImage: NetworkImage("https://picsum.photos/200"),
                ),
              ),
              const SizedBox(height: 20),
              _buildItem(Icons.email, "Email", user!.email),
              _buildItem(
                Icons.person,
                enLang ? "Username" : "Nama pengguna",
                user.username,
              ),
              _buildItem(
                Icons.lock,
                enLang ? "Password" : "Kata sandi",
                "********",
              ),
              _buildItem(
                Icons.wc,
                enLang ? "Gender" : "Jenis Kelamin",
                enLang ? user.gender : genderMap[user.gender] ?? user.gender,
              ),
              _buildItem(
                Icons.movie_filter,
                enLang ? "Fav Genres" : "Genre Favorit",
                user.genres is List
                    ? (user.genres as List)
                        .map((genre) => enLang
                            ? genre
                            : movieGenres
                                    .firstWhere(
                                      (g) => g['en'] == genre,
                                      orElse: () => {'en': genre, 'in': genre},
                                    )['in']!)
                        .join(", ")
                    : user.genres.toString(),
              ),
              _buildItem(
                Icons.cake,
                enLang ? "Birth Date" : "Tanggal Lahir",
                "${user.birthDate.day}/${user.birthDate.month}/${user.birthDate.year}",
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          enLang ? "Confirm Logout" : "Konfirmasi Keluar",
                          style: TextStyle(
                            color: theme ? Colors.white : Colors.black,
                          ),
                        ),
                        content: Text(
                          enLang
                              ? "Are you sure you want to logout?"
                              : "Apakah Anda yakin ingin keluar?",
                          style: TextStyle(
                            color: theme ? Colors.white : Colors.black,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(enLang ? "Cancel" : "Batal"),
                          ),
                          TextButton(
                            onPressed: () {
                              userProvider.userLogout();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    enLang
                                        ? "Logged Out Successfully"
                                        : "Beerhasil Keluar",
                                    style: TextStyle(
                                      color:
                                          theme ? Colors.black : Colors.black,
                                    ),
                                  ),
                                  backgroundColor:
                                      theme ? Colors.white : Colors.black,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            child: Text(enLang ? "Logout" : "Keluar"),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.logout),
                  label: Text(
                    enLang ? "Logout" : "Keluar",
                    style: const TextStyle(fontSize: 16),
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