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
  final List<Map<String, String>> movieGenres = [
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
  final List<Map<String, String>> genderOptions = [
    {'en': 'Male', 'in': 'Laki-laki'},
    {'en': 'Female', 'in': 'Perempuan'},
  ];

  List<String> selectedGenres = [];
  String? selectedGender;
  DateTime? selectedBirthDate;

  void _pickBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedBirthDate = picked;
      });
    }
  }

  void completeProfileButton() {
    final user = Provider.of<UserProvider>(context, listen: false);
    final languageProvider = Provider.of<LanguageProv>(context, listen: false);
    final enLang = languageProvider.currentLanguage == "en";

    final genreValid = selectedGenres.length >= 3;
    final genderValid = selectedGender != null;
    final birthDateValid = selectedBirthDate != null;

    if (!genreValid && !genderValid && !birthDateValid) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
            enLang ? "Incomplete Selection" : "Pilihan Belum Lengkap",
            style: TextStyle(color: Colors.amber),
          ),
          content: Text(enLang
              ? "Please select at least 3 genres, gender and your birth date."
              : "Silakan pilih minimal 3 genre, jenis kelamin dan tanggal lahir Anda."),
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

    if (!birthDateValid) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
            enLang ? "Missing Birth Date" : "Tanggal Lahir Belum Dipilih",
            style: TextStyle(color: Colors.amber),
          ),
          content: Text(enLang
              ? "Please select your birth date"
              : "Silakan pilih tanggal lahir Anda."),
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

    user.updateUser(user.currentUser!.email, selectedGender!, selectedGenres, selectedBirthDate!);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => drawerCreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProv>(context);
    final enLang = languageProvider.currentLanguage == "en";

    print('CompleteProfile - Current language: ${languageProvider.currentLanguage}');
    print('CompleteProfile - enLang: $enLang');

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
                final genreKey = enLang ? genre['en']! : genre['in']!;
                return FilterChip(
                  avatar: const Icon(Icons.movie, size: 18),
                  label: Text(genreKey),
                  selected: selectedGenres.contains(genre['en']!),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedGenres.add(genre['en']!);
                      } else {
                        selectedGenres.remove(genre['en']!);
                      }
                    });
                  },
                  selectedColor: Colors.amber.withOpacity(0.2),
                  checkmarkColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: selectedGenres.contains(genre['en']!)
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
                final genderKey = enLang ? gender['en']! : gender['in']!;
                return RadioListTile<String>(
                  title: Text(genderKey),
                  value: gender['en']!,
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
            const SizedBox(height: 20),
            Text(enLang ? "Select your birth date" : "Pilih tanggal lahir Anda"),
            TextButton.icon(
              onPressed: _pickBirthDate,
              icon: const Icon(Icons.calendar_today),
              label: Text(
                selectedBirthDate == null
                    ? (enLang ? "Pick a date" : "Pilih tanggal")
                    : "${selectedBirthDate!.day}/${selectedBirthDate!.month}/${selectedBirthDate!.year}",
                selectionColor: Colors.white,
              ),
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