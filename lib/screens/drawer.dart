import 'package:flutter/material.dart';
import 'package:flutter_fe/provider/language.dart';
import 'package:flutter_fe/provider/theme.dart';
import 'package:flutter_fe/provider/user.dart';
import 'package:flutter_fe/screens/account_screen.dart';
import 'package:flutter_fe/screens/favoriteScreen.dart';
import 'package:flutter_fe/screens/filterAllMovie.dart';
import 'package:flutter_fe/screens/home_screen.dart';
import 'package:flutter_fe/screens/settings_screen.dart';
import 'package:provider/provider.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  int selectedScreen = 0;

  final List<Widget> screens = [
    HomePage(),
    AccountScreen(),
    settingsScreen(),
    Favoritescreen(),
    Discovermovie(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProv>(context);
    final languageProvider = Provider.of<LanguageProv>(context);

    final user = Provider.of<UserProvider>(context).currentUser;
    final isEnglish = languageProvider.currentLanguage == "en";

    return Scaffold(
      appBar: AppBar(
        title: const Text("MovieFy"),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),
      drawer: Drawer(
        width: 300,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://picsum.photos/300/150?blur"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage("https://picsum.photos/200"),
              ),
              accountName: Text(
                user?.username ?? "Guest",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(user?.email ?? "guest@email.com"),
            ),

            _buildDrawerItem(Icons.home_outlined, "Home", 0, isEnglish),
            _buildDrawerItem(Icons.search_sharp, "Discover", 4, isEnglish),
            _buildDrawerItem(Icons.bookmark_outline, "Favorite", 3, isEnglish),
            _buildDrawerItem(
              Icons.account_circle_outlined,
              "Profile",
              1,
              isEnglish,
            ),
            _buildDrawerItem(Icons.settings_outlined, "Settings", 2, isEnglish),

            const Divider(thickness: 1, height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: SwitchListTile(
                title: Text(isEnglish ? 'Dark Mode' : 'Mode Gelap'),
                secondary: Icon(
                  themeProvider.isDarkMode
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                ),
                value: themeProvider.isDarkMode,
                onChanged: (_) => themeProvider.toggleTheme(),
                activeColor: Colors.amber,
              ),
            ),
          ],
        ),
      ),
      body: IndexedStack(index: selectedScreen, children: screens),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String label,
    int index,
    bool isEnglish,
  ) {
    final isSelected = selectedScreen == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.amber : null),
      title: Text(
        isEnglish ? label : _translate(label),
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w400 : FontWeight.normal,
          color: isSelected ? Colors.amber : null,
        ),
      ),
      tileColor: isSelected ? Colors.amber.withOpacity(0.1) : null,
      onTap: () {
        setState(() {
          selectedScreen = index;
        });
        Navigator.pop(context);
      },
    );
  }

  String _translate(String label) {
    switch (label) {
      case "Home":
        return "Beranda";
      case "Profile":
        return "Profil";
      case "Discover":
        return "Menemukan";
      case "Favorite":
        return "Favorit";
      case "Settings":
        return "Pengaturan";
      default:
        return label;
    }
  }
}
