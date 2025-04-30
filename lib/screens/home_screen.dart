import 'package:flutter/material.dart';
import 'package:flutter_fe/screens/watch_screen.dart';
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
  TextEditingController _searchCtr = TextEditingController();
  String _searchTextField = "";
  String _selectedLanguage = 'English';
  bool _isDarkMode = false;

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
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.menu),
          ),
        ),
        title: Text("MovieFy"),
        actions: [
          SizedBox(
            width: 150,
            height: 40,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchTextField = value;
                });
              },
              controller: _searchCtr,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: "Search movie",
                filled: true,
                fillColor: Color(0xFFCCD0CF),
                hintStyle: TextStyle(
                  color: const Color.fromARGB(255, 117, 117, 117),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
              ),
            ),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        ],
      ),
      drawer: Drawer(
        width: 225,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              color: const Color.fromARGB(255, 25, 24, 25),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14, 
                    backgroundColor: Colors.white,
                    child: Text(
                      'A',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: const Color.fromARGB(255, 80, 80, 80), // transparan, samar
              thickness: 1,
              height: 1,
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: DropdownButton<String>(
                value: _selectedLanguage,
                items: [
                  DropdownMenuItem(
                    value: 'English',
                    child: Text('English', style: TextStyle(color: Colors.white)),
                  ),
                  DropdownMenuItem(
                    value: 'Indonesian',
                    child: Text('Indonesian', style: TextStyle(color: Colors.white)),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                },
                isExpanded: true,
                underline: SizedBox(),
              ),
            ),
            SwitchListTile(
              title: Text('Theme'),
              secondary: Icon(
                _isDarkMode ? Icons.dark_mode : Icons.light_mode),
              value: _isDarkMode,
              onChanged: (val) {
                setState(() {
                  _isDarkMode = val;
                });
              },
              activeColor: Colors.purple, 
              inactiveThumbColor: Colors.grey, 
            ),
          ],
        ),
      ),
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
                      "Top Movie",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 20),
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
                      "Top Rated Movie",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 20),
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
                                            topRatedMovies[index]
                                                    ["vote_average"]
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
                      "Upcoming Movie",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 200,
              child: upcomingMovies.isEmpty
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
                                builder: (context) => WatchPage(
                                  titleMovie: upcomingMovies[index]['title'],
                                  descMovie: upcomingMovies[index]['overview'],
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
                                      upcomingMovies[index]["poster_path"]),
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
