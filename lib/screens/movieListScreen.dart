import 'package:flutter/material.dart';
import 'package:flutter_fe/screens/watch_screen.dart';
import '../utils/api.dart';

class Movielistscreen extends StatefulWidget {
  const Movielistscreen({super.key, required this.searchValue});
  final searchValue;

  @override
  State<Movielistscreen> createState() => _MovielistscreenState();
}

class _MovielistscreenState extends State<Movielistscreen> {
  List<dynamic> movies = [];

  Future<void> fetchingMovies() async {
    final search = widget.searchValue;
    try {
      final response = await getMoviesBySearch(search);
      setState(() {
        final tmp = response['results'];
        if (tmp.isNotEmpty) {
          movies = tmp;
        } else {
          movies = [
            {"title": "Hasil pencarian tidak ada"},
          ];
        }
        print("isi b ${movies[16]}");
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    fetchingMovies();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child:
            movies.isEmpty
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => WatchPage(
                                  idMovie: movies[index]["id"].toString(),
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
                              getImageUrl(movies[index]["poster_path"]),
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
                                    movies[index]['title'],
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
                                        (movies[index]["vote_average"] as num)
                                            .toDouble()
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
    );
  }
}
