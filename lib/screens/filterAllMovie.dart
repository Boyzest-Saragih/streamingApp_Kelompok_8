import 'package:flutter/material.dart';
import 'package:flutter_fe/screens/searchScreen.dart';
import 'package:flutter_fe/screens/watch_screen.dart';
import '../utils/api.dart';

class Discovermovie extends StatefulWidget {
  final bool filterable;

  const Discovermovie({
    super.key,
    this.filterable = false,
  });

  @override
  State<Discovermovie> createState() => _DiscovermovieState();
}

class _DiscovermovieState extends State<Discovermovie> {
  List<dynamic> allMovie = [];
  List<dynamic> filteredMovie = [];
  DateTimeRange? pickedRange;

  @override
  void initState() {
    super.initState();
    fetchAllMovie();
  }

  Future<void> fetchAllMovie() async {
    final popular = await getPopularMovies();
    final topRated = await getTopRatedMovies();
    final upcoming = await getUpcomingMovies();

    final combined = [
      ...popular["results"],
      ...topRated["results"],
      ...upcoming["results"],
    ];

    setState(() {
      allMovie = combined;
      filteredMovie = combined;
    });
  }

  Future<void> pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final fromDate = _formatDate(picked.start);
      final toDate = _formatDate(picked.end);

      final result = await getMoviesByDate(fromDate, toDate);
      if (result != null && result["results"] != null) {
        setState(() {
          pickedRange = picked;
          filteredMovie = result["results"];
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, "0")}/"
        "${date.month.toString().padLeft(2, "0")}/"
        "${date.day.toString().padLeft(2, "0")}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchScreen()),
          );
        },
        backgroundColor: Colors.amber,
        child: const Icon(Icons.search),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (pickedRange != null)
                  Expanded(
                    child: Text(
                      "${_formatDate(pickedRange!.start)} - ${_formatDate(pickedRange!.end)}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                if (pickedRange != null)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        pickedRange = null;
                        filteredMovie = allMovie;
                      });
                    },
                    icon: const Icon(Icons.clear),
                  ),
                IconButton(
                  onPressed: pickDateRange,
                  icon: const Icon(Icons.filter_alt),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Expanded(
              child: GridView.builder(
                itemCount: filteredMovie.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final movie = filteredMovie[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WatchPage(
                            idMovie: movie["id"].toString(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(
                            getImageUrl(movie["poster_path"]),
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
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black, Colors.transparent],
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  movie["title"] ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      movie["vote_average"].toStringAsFixed(2),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
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
