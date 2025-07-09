import 'package:flutter/material.dart';
import 'package:flutter_fe/provider/language.dart';
import 'package:flutter_fe/provider/theme.dart';
import 'package:flutter_fe/provider/user.dart';
import 'package:flutter_fe/screens/account_screen.dart';
import 'package:flutter_fe/screens/favoriteScreen.dart';
import 'package:flutter_fe/screens/home_screen.dart';
import 'package:flutter_fe/screens/settings_screen.dart';
import 'package:provider/provider.dart';

class drawerCreen extends StatefulWidget {
  const drawerCreen({super.key});

  @override
  State<drawerCreen> createState() => _drawerCreenState();
}

class _drawerCreenState extends State<drawerCreen> {
  TextEditingController _searchCtr = TextEditingController();
  String _searchTextField = "";
  String _selectedLanguage = 'en';

  List<Widget> screen = [HomePage(), AccountScreen(), settingsScreen(),Favoritescreen()];
  int selectScreen = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProv>(context);
    final theme = themeProvider.isDarkMode;
    final users = Provider.of<UserProvider>(context);
    final user = users.currentUser;
    final languageProvider = Provider.of<LanguageProv>(context);
    final enLang = languageProvider.currentLanguage == "en" ? true : false;
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder:
              (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: Icon(Icons.menu),
              ),
        ),
        title: Text("MovieFy"),
      ),
      drawer: Drawer(
        width: 300,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://picsum.photos/200/?blur"),
                  fit: BoxFit.cover,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage("https://picsum.photos/200"),
              ),
              accountName: Text(user!.username),
              accountEmail: Text(user!.email),
            ),

            ListTile(
              leading: Tooltip(
                message: enLang ? "Go to Home" : "Ke Beranda",
                child: Icon(Icons.home),
              ),
              title: Text("Home"),
              onTap: () {
                setState(() {
                  selectScreen = 0;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: Tooltip(
                message: enLang ? "View Profile" : "Lihat Profil",
                child: Icon(Icons.account_box),
              ),
              title: Text("Profile"),
              onTap: () {
                setState(() {
                  selectScreen = 1;
                  Navigator.pop(context);
                });
              },
            ),

            ListTile(
              leading: Tooltip(
                message: enLang ? "Open Settings" : "Buka Pengaturan",
                child: Icon(Icons.settings),
              ),
              title: Text("Settings"),
              onTap: () {
                setState(() {
                  selectScreen = 2;
                  Navigator.pop(context);
                });
              },
            ),


            ListTile(
              leading: Icon(Icons.bookmark),
              title: Text("Favorite"),
              onTap: () {
                setState(() {
                  selectScreen = 3;
                  Navigator.pop(context);
                });
              },
            ),

            SwitchListTile(
              title: Text(
                enLang ? 'Theme' : "Tema",
                style: Theme.of(context).textTheme.titleSmall,
              ),

              ),
              value: themeProvider.isDarkMode,
              onChanged: (val) {
                setState(() {
                  themeProvider.toggleTheme();
                });
              },
              activeColor: Colors.amber,
              inactiveThumbColor: Colors.grey,
            ),
          ],
        ),
      ),
      body: screen[selectScreen],
    );
  }
}