import 'package:flutter/material.dart';
import 'package:flutter_fe/provider/favoriteMovies.dart';
import 'package:flutter_fe/provider/user.dart';
import 'package:flutter_fe/utils/api.dart'; // untuk getImageUrl
import 'package:flutter_fe/screens/watch_screen.dart'; // jika belum import
import 'package:provider/provider.dart';

class Favoritescreen extends StatefulWidget {
  const Favoritescreen({super.key});

  @override
  State<Favoritescreen> createState() => _FavoritescreenState();
}

class _FavoritescreenState extends State<Favoritescreen> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<UserProvider>(context);
    final user = users.currentUser;
    final favoriteMovies = Provider.of<FavoriteMoviesProvider>(context);

    final favorite = favoriteMovies.getFavorites(user!.userId.toString());

    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: favorite.isEmpty
            ? const Center(
                child: Text(
                  "No favorite movies yet.",
                  style: TextStyle(fontSize: 16),
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.6,
                ),
                itemCount: favorite.length,
                itemBuilder: (context, index) {
                  final movie = favorite[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WatchPage(
                            idMovie: movie.movieId,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: movie.posterPath != null
                            ? DecorationImage(
                                image: NetworkImage(
                                  getImageUrl(movie.posterPath),
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: Colors.grey[300],
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(8),
                            ),
                          ),
                          child: Text(
                            movie.title ?? 'No Title',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
