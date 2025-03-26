import 'package:flutter/material.dart';
import '../utils/api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<dynamic> movieFuture;
  bool _isDarkMode = false; // Default ke mode terang

  @override
  void initState() {
    super.initState();
    movieFuture = getMoviesByType();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(), // Mengatur tema berdasarkan mode
      home: Scaffold(
        // AppBar
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(), // Hamburger Button
            ),
          ),
          title: Text("Movie App"),
          actions: [
            // Toggle Light/Dark Mode
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                setState(() {
                  _isDarkMode = !_isDarkMode; // Mengubah status mode
                });
              },
            ),
            // Profile Picture
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Ganti dengan URL profile
              ),
            ),
          ],
        ),

        // Drawer for Hamburger Menu
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(title: Text('Home'), onTap: () => Navigator.pop(context)),
              ListTile(title: Text('Profile'), onTap: () => Navigator.pop(context)),
              ListTile(title: Text('Settings'), onTap: () => Navigator.pop(context)),
            ],
          ),
        ),

        // Body
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner Top Movies
              Container(
                height: 200,
                width: double.infinity,
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage('https://image.tmdb.org/t/p/w500/insert-poster-path-here'), // Ganti dengan poster dari API
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black54, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Top Movie Title',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),

              // Movie List Grouped by Type
              Padding(
                padding: EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: movieFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data['results'] == null) {
                      return Center(child: Text('No movies found'));
                    }

                    List movies = snapshot.data['results'];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Popular Movies', style: Theme.of(context).textTheme.headlineSmall),
                        SizedBox(
                          height: 250,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                                                        itemCount: movies.length,
                            itemBuilder: (context, index) {
                              var movie = movies[index];
                              return MovieCard(movie: movie);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Bottom Navigation Bar
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          ],
          currentIndex: 0,
          onTap: (index) {
            // Handle navigation
          },
        ),
      ),
    );
  }
}

// Widget untuk Card Movie
class MovieCard extends StatelessWidget {
  final dynamic movie;

  const MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(right: 8.0),
      child: Card(
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
              child: Image.network(
                'https://image.tmdb.org/t/p/w154${movie["poster_path"]}',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 150,
                  color: Colors.grey,
                  child: Icon(Icons.image_not_supported),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie['title'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.yellow),
                      SizedBox(width: 4),
                      Text('${movie["vote_average"]}/10'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}