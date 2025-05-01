import 'package:flutter/material.dart';
import 'package:flutter_fe/provider/user.dart';
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
    'Non-binary',
    'Bebek',
    'Mie Ayam',
    'Prefer not to say',
  ];

  List<String> selectedGenres = [];
  String? selectedGender;

  void completeProfileButton() {
    final user = Provider.of<User>(context, listen: false);
    if (selectedGender!.isNotEmpty && selectedGender!.isNotEmpty) {
      user.addUserData(user.currentUser[0], selectedGender, selectedGenres);
      user.getUserLogin(user.currentUser[1][0]);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Your Profile")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text("Select at least 3 Genres"),
            const SizedBox(height: 15),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  movieGenres.map((genre) {
                    return FilterChip(
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
                          color:
                              selectedGenres.contains(genre)
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
            const Text("Select your gender"),
            Column(
              children:
                  genderOptions.map((gender) {
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
              onPressed: selectedGender != null ? completeProfileButton : null,
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
