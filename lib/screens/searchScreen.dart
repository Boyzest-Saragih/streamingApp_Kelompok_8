import 'package:flutter/material.dart';
import 'package:flutter_fe/screens/watch_screen.dart';
import '../utils/api.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _search = TextEditingController();
  List<dynamic> movies = [];
  bool isLoad = false;

  Future<void> fetchMovies(String query) async {
    setState(() {
      isLoad = true;
    });
    try {
      final response = await getMoviesBySearch(query);
      setState(() {
        final tmp = response['results'];
        movies = tmp;
      });
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        isLoad = false;
      });
    }
  }

  void handleSearch(String query) {
    if (query.isEmpty) return;
    fetchMovies(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  elevation: 2,
  toolbarHeight: 70,
  title: Container(
    height: 45,
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(25),
    ),
    child: TextField(
      controller: _search,
      onSubmitted: handleSearch,
      textInputAction: TextInputAction.search,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: "Cari film...",
        hintStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(vertical: 10),
        border: InputBorder.none,
      ),
    ),
  ),
  actions: [
    IconButton(
      icon: const Icon(Icons.close, color: Colors.grey),
      onPressed: () {
        setState(() {
          _search.clear();
          movies.clear();
        });
      },
    ),
  ],
),

      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child:
                  isLoad
                      ? Center(child: CircularProgressIndicator())
                      : movies.isEmpty
                      ? Center(child: Text("Tidak ada hasil"))
                      : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.8
                        ),
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => WatchPage(
                                        idMovie: movie['id'].toString(),
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              width: 150,
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    getImageUrl(movie['poster_path']),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black,
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          movie['title'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              movie["vote_average"]
                                                  .toStringAsFixed(2),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}