import 'package:flutter/material.dart';
import 'package:flutter_fe/screens/watch_screen.dart';
import '../utils/api.dart';

class movielistpage extends StatefulWidget {
  final String title;
  final List<dynamic> movies;
  final bool filterable;

  const movielistpage({
    super.key,
    required this.title,
    required this.movies,
    this.filterable = false,
  });

  @override
  State<movielistpage> createState() => _movielistpageState();
}

class _movielistpageState extends State<movielistpage> {
  List<dynamic> TampilkanMovie = [];
  DateTimeRange? pickedRange;

  @override
  void initState() {
    super.initState();
    TampilkanMovie = widget.movies;
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
      ),
      body:
          TampilkanMovie.isEmpty
              ? Center(child: Text("No movies found"))
              : ListView.builder(
                itemCount: TampilkanMovie.length,
                itemBuilder: (context, index) {
                  final movie = TampilkanMovie[index];
                  return ListTile(
                    leading: Image.network(
                      getImageUrl(movie["poster_path"]),
                      width: 70,
                      fit: BoxFit.cover,
                    ),
                    title: Text(movie["title"]),
                    subtitle: Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.yellow),
                        SizedBox(width: 4),
                        Text(movie["vote_average"].toStringAsFixed(2)),
                      ],
                    ),
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
                  );
                },
              ),
    );
  }
}
