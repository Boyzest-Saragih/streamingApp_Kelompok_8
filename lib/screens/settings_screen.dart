import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fe/provider/language.dart';
import 'package:share_plus/share_plus.dart';

class settingsScreen extends StatefulWidget {
  const settingsScreen({super.key});

  @override
  State<settingsScreen> createState() => _settingsScreenState();
}

class _settingsScreenState extends State<settingsScreen> {
  String? _selectedLanguage;

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProv>(context);
    final isEnglish = languageProvider.currentLanguage == 'en';
    _selectedLanguage = languageProvider.currentLanguage;

    void shareApp(BuildContext context) {
      final linkApp =
          "https://github.com/Boyzest-Saragih/streamingApp_Kelompok_8.git";
      Share.share("Gas Streaming di MovieFy! 🎬\n$linkApp");
    }

    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.language),
            title: Text(isEnglish ? "Language" : "Bahasa"),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              items: [
                DropdownMenuItem(
                  value: 'en',
                  child: Text(
                    "English",
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 1),

                        content: Text("Switch Language to English"),
                        action: SnackBarAction(
                          label: 'Ok!',
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),
                      ),
                    );
                  },
                ),
                DropdownMenuItem(
                  value: 'in',
                  child: Text(
                    "Indonesian",
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 1),

                        content: Text("Mengganti Bahasa ke Indonesia"),
                        action: SnackBarAction(
                          label: 'Ok!',
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                  languageProvider.changeLanguage(value);
                });
              },
              underline: SizedBox(),
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.share),
            title: Text(isEnglish ? "Share App" : "Bagikan Aplikasi"),
            onTap: () {
              shareApp(context);
            },
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text(isEnglish ? "App Info" : "Tentang Aplikasi"),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "MovieFy",
                applicationVersion: "1.0.0",
                applicationIcon: Icon(Icons.movie),
                children: [
                  Text(
                    isEnglish
                        ? "MovieFy is a simple movie app for practice and learning."
                        : "MovieFy adalah aplikasi film sederhana untuk latihan dan pembelajaran.",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.group),
            title: Text(isEnglish ? "Developer Team" : "Tim Pengembang", style: TextStyle(color: Colors.white),),
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        isEnglish ? "Developer Info" : "Informasi Pengembang",
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              "https://avatars.githubusercontent.com/u/138434387?v=4",
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "• Enjel  • Rifky  • Indra  • Dedi",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                             "Team Kewek Kewek 😂",
                            style: TextStyle(color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                                "Pengembang di balik MovieFy. Fokus membangun aplikasi film yang bersih dan fungsional layaknya pengganti netflix 2026",
                            style: TextStyle(fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          child: Text(isEnglish ? "Close" : "Tutup"),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
    );
  }
}
