import 'package:flutter/material.dart';
import 'package:flutter_fe/provider/language.dart';
import 'package:flutter_fe/provider/theme.dart';
import 'package:flutter_fe/provider/user.dart';
import 'package:flutter_fe/screens/account_screen.dart';
import 'package:flutter_fe/screens/watch_screen.dart';
import 'package:provider/provider.dart';
import '../utils/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> popularMovies = [];
  List<dynamic> topRatedMovies = [];
  List<dynamic> upcomingMovies = [];

  @override
  void initState() {
    super.initState();
    fetchingMovies();
  }

  Future<void> fetchingMovies() async {
    try {
      final responsePopularMovies = await getPopularMovies();
      final responseTopRatedMovies = await getTopRatedMovies();
      final responseUpcomingMovies = await getUpcomingMovies();
      setState(() {
        popularMovies = responsePopularMovies['results'];
        topRatedMovies = responseTopRatedMovies['results'];
        upcomingMovies = responseUpcomingMovies['results'];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProv>(context);
    final theme = themeProvider.isDarkMode;
    final users = Provider.of<User>(context);
    final user = users.currentUser[1];
    final languageProvider = Provider.of<LanguageProv>(context);
    final enLang = languageProvider.currentLanguage == "en" ? true : false;

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){},child: Icon(Icons.search),backgroundColor: Colors.amber,),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(),

            const SizedBox(height: 20),

            // Top List
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      enLang ? "Top Movie" : "Film Teratas",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: theme ? Colors.white : Colors.black,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),

            SizedBox(
              height: 200,
              child:
                  popularMovies.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: popularMovies.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => WatchPage(
                                        titleMovie:
                                            popularMovies[index]['title'],
                                        descMovie:
                                            popularMovies[index]['overview'],
                                        releaseDateMovie:
                                            popularMovies[index]['release_date'],
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
                                    getImageUrl(
                                      popularMovies[index]["poster_path"],
                                    ),
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
                                          popularMovies[index]['title'],
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
                                              popularMovies[index]["vote_average"]
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

            const SizedBox(height: 40),

            // Top Rated List
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      enLang ? "Top Rated Movie" : "Film Nilai Tertinggi",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: theme ? Colors.white : Colors.black,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 200,
              child:
                  topRatedMovies.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: topRatedMovies.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => WatchPage(
                                        titleMovie:
                                            topRatedMovies[index]['title'],
                                        descMovie:
                                            topRatedMovies[index]['overview'],
                                        releaseDateMovie:
                                            topRatedMovies[index]['release_date'],
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
                                    getImageUrl(
                                      topRatedMovies[index]["poster_path"],
                                    ),
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
                                          topRatedMovies[index]['title'],
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
                                              topRatedMovies[index]["vote_average"]
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
            const SizedBox(height: 40),

            // Upcoming List
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      enLang ? "Upcoming Movie" : "Film Mendatang",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: theme ? Colors.white : Colors.black,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 200,
              child:
                  upcomingMovies.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: upcomingMovies.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => WatchPage(
                                        titleMovie:
                                            upcomingMovies[index]['title'],
                                        descMovie:
                                            upcomingMovies[index]['overview'],
                                        releaseDateMovie:
                                            upcomingMovies[index]['release_date'],
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
                                    getImageUrl(
                                      upcomingMovies[index]["poster_path"],
                                    ),
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
                                          upcomingMovies[index]['title'],
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
                                              upcomingMovies[index]["vote_average"]
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
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
