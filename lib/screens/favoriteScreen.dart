import 'package:flutter/material.dart';
import 'package:flutter_fe/provider/favoriteMovies.dart';
import 'package:flutter_fe/provider/language.dart';
import 'package:flutter_fe/provider/user.dart';
import 'package:flutter_fe/utils/api.dart';
import 'package:flutter_fe/screens/watch_screen.dart';
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
    final languageProvider = Provider.of<LanguageProv>(context);
    final enLang = languageProvider.currentLanguage == "en";

    print('FavoriteScreen - Current language: ${languageProvider.currentLanguage}');
    print('FavoriteScreen - enLang: $enLang');

    final favorite = favoriteMovies.getFavorites(user!.userId.toString());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            favorite.isEmpty
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
                    childAspectRatio: 0.8,
                  ),
                  itemCount: favorite.length,
                  itemBuilder: (context, index) {
                    final movie = favorite[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => WatchPage(idMovie: movie.movieId),
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
                              getImageUrl(movie.posterPath),
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
                                  colors: [Colors.black, Colors.transparent],
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    movie.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
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
                                        movie.rating
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
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