import 'package:flutter/material.dart';
import '../utils/api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<dynamic> movieFuture;

  @override
  void initState() {
    super.initState();
    movieFuture = getMoviesByType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Movie"), backgroundColor: Colors.blue),
      body: FutureBuilder(
        future: movieFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("terjadi kesalahan : ${snapshot.error}"));
          } else if (snapshot.data == null || snapshot.data["results"] == null) {
            return Center(child: Text("no data yet"));
          }

          List movies = snapshot.data["results"];
          
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index){
              var movie = movies[index];
              return ListTile(
                title: Text(movie["title"]),
              );
            },
          )
          
          ;

        },
      ),
    );
  }
}
