import 'package:flutter/material.dart';
import 'package:flutter_fe/provider/language.dart';
import 'package:flutter_fe/provider/user.dart';
import 'package:flutter_fe/screens/drawer.dart';
import 'package:flutter_fe/screens/home_screen.dart';
import 'package:provider/provider.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final List<String> movieGenres = [
    "Action",
    "Adventure",
    "Animation",
    "Comedy",
    "Crime",
    "Documentary",
    "Drama",
    "Fantasy",
    "Historical",
    "Horror",
    "Musical",
    "Mystery",
    "Romance",
    "Science Fiction",
    "Thriller",
    "Western",
    "War",
    "Biography",
    "Family",
    "Sports",
    "Superhero",
    "Noir",
    "Psychological",
    "Disaster",
  ];
  final List<String> genderOptions = [
    'Male',
    'Female',
  ];

  List<String> selectedGenres = [];
  String? selectedGender;

  void completeProfileButton() {
    final user = Provider.of<UserProvider>(context, listen: false);
    final languageProvider = Provider.of<LanguageProv>(context, listen: false);
    final enLang = languageProvider.currentLanguage == "en";

    final genreValid = selectedGenres.length >= 3;
    final genderValid = selectedGender != null;

    if (!genreValid && !genderValid) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
            enLang ? "Incomplete Selection" : "Pilihan Belum Lengkap",
            style: TextStyle(color: Colors.amber),
          ),
          content: Text(enLang
              ? "Please select at least 3 genres and your gender."
              : "Silakan pilih minimal 3 genre dan jenis kelamin Anda."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    if (!genreValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            enLang ? "Please select at least 3 genres" : "Pilih minimal 3 genre",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!genderValid) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
            enLang ? "Missing Gender" : "Gender Belum Dipilih",
            style: TextStyle(color: Colors.amber),
          ),
          content: Text(enLang
              ? "Please select your gender"
              : "Silakan pilih jenis kelamin Anda."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    user.updateUser(user.currentUser!.email, selectedGender!, selectedGenres);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => drawerCreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProv>(context);
    final enLang = languageProvider.currentLanguage == "en" ? true : false;

    return Scaffold(
      appBar: AppBar(
        title: Text(enLang ? "Complete Your Profile" : "Lengkapi Profil Anda"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(enLang ? "Select at least 3 Genres" : "Pilih minimal 3 Genre"),
            const SizedBox(height: 15),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: movieGenres.map((genre) {
                return FilterChip(
                  avatar: const Icon(Icons.movie, size: 18),
                  label: Text(genre),
                  selected: selectedGenres.contains(genre),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedGenres.add(genre);
                      } else {
                        selectedGenres.remove(genre);
                      }
                    });
                  },
                  selectedColor: Colors.amber.withOpacity(0.2),
                  checkmarkColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: selectedGenres.contains(genre)
                          ? Colors.amber
                          : Colors.grey,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 20),
            Text(enLang ? "Select your gender" : "Pilih jenis kelamin Anda"),
            Column(
              children: genderOptions.map((gender) {
                return RadioListTile(
                  title: Text(gender),
                  value: gender,
                  groupValue: selectedGender,
                  onChanged: (String? value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                  activeColor: Colors.amber,
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: completeProfileButton,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: const Text("Next", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}