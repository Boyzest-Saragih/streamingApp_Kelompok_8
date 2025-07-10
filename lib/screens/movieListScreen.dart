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

  Future<void> pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2006),
      lastDate: DateTime(2025),
    );


    if (picked != null) {
      setState(() {
        pickedRange = picked;
        TampilkanMovie = widget.movies.where((movie) {
          final date = movie["release_date"];
          if (date == null || date.isEmpty){
            return false;
        }
          final releaseDate = DateTime.tryParse(date);
          return releaseDate != null &&
            releaseDate.isAfter(picked.start.subtract(Duration(days: 1))) &&
            releaseDate.isBefore(picked.end.add(Duration(days: 1)));
        }).toList();
    });
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
        title: Text(widget.title, style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis
        ),),
        actions: [
          if (pickedRange != null)
          Padding(padding: const EdgeInsets.only(right: 8),
          child: Text( "${_formatDate(pickedRange!.start)} - ${_formatDate(pickedRange!.end)}",
          style: TextStyle(fontSize: 12),
          ),
          ),
          if (pickedRange != null)
          IconButton(
            onPressed: (){
              setState(() {
                pickedRange = null;
                TampilkanMovie = widget.movies;
              });
            }, 
            icon: Icon(Icons.clear)),
          IconButton(onPressed: pickDateRange, 
          icon: const Icon(Icons.filter_alt))
        ],
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
                              (context) => WatchPage(
                                idMovie: movie["id"].toString(),
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
