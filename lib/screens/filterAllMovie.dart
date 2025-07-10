import 'package:flutter/material.dart';
import 'package:flutter_fe/screens/watch_screen.dart';
import '../utils/api.dart';

class filterAllmovie extends StatefulWidget {
  final String title;
  final bool filterable;

  const filterAllmovie({
    super.key,
    required this.title,
    this.filterable = false,
  });

  @override
  State<filterAllmovie> createState() => _filterAllmovieState();
}

class _filterAllmovieState extends State<filterAllmovie> {
  List<dynamic> allMovie = [];
  List<dynamic> filteredMovie = [];
  DateTimeRange? pickedRange;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllMovie();
  }

  Future<void> fetchAllMovie() async {
    setState(() {
      isLoading = true;
    });

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
      isLoading = false;
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        actions: [
          if (pickedRange != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                "${_formatDate(pickedRange!.start)} - ${_formatDate(pickedRange!.end)}",
                style: TextStyle(fontSize: 12),
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
              icon: Icon(Icons.clear),
            ),
          IconButton(
            onPressed: pickDateRange,
            icon: const Icon(Icons.filter_alt),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : filteredMovie.isEmpty
              ? Center(child: Text("No movies found"))
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: filteredMovie.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.6,
                  ),
                  itemBuilder: (context, index) {
                    final movie = filteredMovie[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    WatchPage(idMovie: movie["id"].toString()),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(8),
                              child: Image.network(
                                getImageUrl(movie["poster_path"]),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            movie["title"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.yellow,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                movie["vote_average"].toStringAsFixed(2),
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
