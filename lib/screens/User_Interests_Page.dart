import 'package:flutter/material.dart';
import 'package:flutter_fe/screens/home_screen.dart';
import 'package:flutter_fe/utils/api.dart';
import 'package:http/http.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  List<dynamic> genreMovies = [];
  List<int> selectedGenreIds = [];

  @override
  void initState() {
    super.initState();
    fetchingMovies();
  }

  Future<void> fetchingMovies() async {
    final responseGenreMovies = await getGenreMovies();
    print("Fetched genres: $responseGenreMovies");
    
    if (responseGenreMovies != null) {
      setState(() {
        genreMovies = responseGenreMovies;
      });
    }
  }

  @override

  String selectedGender = '';


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06141B),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 50, 25, 15),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("🎯", style: TextStyle(fontSize: 35)),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Choose Your",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Favorite Genre",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Get movie and series recommendations based on your preferences",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: 450,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFF11212D),
                borderRadius: BorderRadius.circular(15),
              ),
              child: genreMovies.isEmpty? const Text("Loading...") 
                  :Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        genreMovies.map((result) {
                          return FilterChip(
                            backgroundColor: Color(0xFF57707A),
                            labelStyle: TextStyle(color: Colors.white70),
                            selectedColor: Color(0xFF7DA0CA),
                            shape: StadiumBorder(
                              side: BorderSide(color: Colors.white24)
                            ),
                            label: Text(
                              result['name'],
                              style: TextStyle(fontSize: 10),
                            ),
                            selected: selectedGenreIds.contains(result['id']),
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                selectedGenreIds.add(result['id']);
                              } else {
                                selectedGenreIds.remove(result['id']);
                              }
                                
                              });
                            },
                          );
                        }).toList(),
                      ),
            ),

            Padding(padding : const EdgeInsets.only(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select gender", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                Row(
                  children: [
                    Expanded(child: RadioListTile(
                      activeColor: Colors.lightBlue,
                      title: Text("Laki-laki", style: TextStyle(fontSize: 18),),
                      value: "Laki-laki",
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value!;
                        });

                      })
                      ),
                      Expanded(child: RadioListTile(
                        activeColor: Colors.pinkAccent,
                        title: Text("Perempuan", style: TextStyle(fontSize: 18),),
                        value: "Perempuan",
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value!;
                          });

                      })
                      ),
                  ],
                ),
                const SizedBox(height: 30,),
                Center(
                  child: SizedBox(
                  height: 40, width: 450,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage(),
                              ),
                            );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: const Text("Next", style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                ),
                ),
                
              ],
            ),)
          ],
        ),
      ),
    );
  }
}
