import 'package:flutter/material.dart';
import 'package:flutter_fe/screens/movieListScreen.dart';

class Searchscreen extends StatefulWidget {
  const Searchscreen({super.key});

  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  final TextEditingController _search = TextEditingController();
  String searchTextValue = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
                  Navigator.pop(context);
                }),
                const SizedBox(width: 4),

                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchTextValue = value;
                      });
                    },
                    controller: _search,
                    decoration: InputDecoration(
                      hintText: "type here",
                      filled: true,
                      fillColor: const Color.fromARGB(255, 0, 0, 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                Movielistscreen(searchValue: searchTextValue),
                      ),
                    );
                  },
                ),
              ],
            ),
            Center(child: Text("History search value here anak ayam, bentuk List Tile harusnya with hapus button")),
          ],
        ),
      ),
    );
  }
}
