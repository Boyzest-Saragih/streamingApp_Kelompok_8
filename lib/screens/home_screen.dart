import 'package:flutter/material.dart';
import 'package:flutter_fe/provider/language.dart';
import 'package:flutter_fe/provider/theme.dart';
import 'package:flutter_fe/screens/movieListScreen.dart';
import 'package:flutter_fe/screens/searchScreen.dart';
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
  List<dynamic> filteredMovie = [];

  bool isfiltered = false;

  DateTimeRange ? pickedRange;
  

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
      if (result!= null && result["results"] != null) {
        setState(() {
          pickedRange = picked;
          filteredMovie = result["results"];
          isfiltered = true;
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
    final themeProvider = Provider.of<ThemeProv>(context);
    final theme = themeProvider.isDarkMode;
    final languageProvider = Provider.of<LanguageProv>(context);
    final enLang = languageProvider.currentLanguage == "en" ? true : false;

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
      },child: Icon(Icons.search),backgroundColor: Colors.amber,),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton.icon(
                onPressed: pickDateRange, 
                icon: Icon(Icons.date_range),
                label: Text(
                  pickedRange == null
                  ? (enLang ? "Date Filter" : "Filter Tanggal")
                  :"${_formatDate(pickedRange!.start)} - ${_formatDate(pickedRange!.end)}"
                )
                ),
            ),

            const SizedBox(height: 10,),

            // movie date filter
            isfiltered
            ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(child: Text( enLang? "Selected Movie" : "Film Pilihanmu",
                    
                        style: Theme.of(context).textTheme.titleMedium
                          ),
                    ),
                  TextButton(
                    onPressed: (){
                      setState(() {
                        isfiltered = false;
                        filteredMovie = [];
                        pickedRange = null;
                      });
                    }, 
                    child: Text( enLang? "Clear" : "Hapus"))
                ],
              ),
            ): const SizedBox(),
            
            const SizedBox(height: 10,),

            isfiltered
            ? SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final movie = filteredMovie[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => WatchPage(
                            idMovie: movie["id"].toString()),
                        ),
                      );
                    },
                    child: Container(
                      width: 150,
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(getImageUrl(movie["poster_path"])),
                          fit: BoxFit.cover,
                        )
                      ),
                      child: Column( mainAxisAlignment: MainAxisAlignment.end,
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
                                Colors.transparent
                                ]
                              )
                            ),
                            child: Column(
                              children: [
                                Text(
                                  movie["title"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                                const SizedBox(width: 4,),
                                Text(movie["vote_average"].toStringAsFixed(2))
                                ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              )  
            ) :const SizedBox(),
            
            isfiltered 
            ? SizedBox(height: 40,)
            : SizedBox.shrink(),


            // Top List
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => movielistpage(
                      title: enLang? "Top Movie" : "Folm Teratas", 
                      movies: popularMovies,
                      filterable: true,
                    ),),
                  );
                },
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
                                        idMovie: popularMovies[index]["id"].toString()
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
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => movielistpage(
                      title: enLang? "Top Rated Movie" : "Film Nilai Tertinggi", 
                      movies: topRatedMovies,
                      filterable: true,
                    ),),
                  );
                },
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
                                        idMovie: topRatedMovies[index]["id"].toString(),
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
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => movielistpage(
                      title: enLang? "Upcoming Movie" : "Film Mendatang", 
                      movies: upcomingMovies,
                      filterable: true,
                    ),),
                  );
                },
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
                                        idMovie: upcomingMovies[index]["id"].toString()
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