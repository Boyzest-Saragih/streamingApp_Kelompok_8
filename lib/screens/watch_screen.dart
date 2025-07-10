import 'package:flutter/material.dart';
import 'package:flutter_fe/provider/favoriteMovies.dart';
import 'package:flutter_fe/provider/user.dart';
import 'package:flutter_fe/utils/api.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WatchPage extends StatefulWidget {
  final String idMovie;

  const WatchPage({super.key, required this.idMovie});

  @override
  State<WatchPage> createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> {
  YoutubePlayerController? _controller;
  Map<String, dynamic>? movieData;
  Map<String, dynamic>? movieVideosData;

  String videoUrl = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);

    final detailFuture = getDetailMovie(widget.idMovie);
    final videoFuture = getMovieVideo(widget.idMovie);

    final detail = await detailFuture;
    final videos = await videoFuture;

    print(detail);
    setState(() {
      movieData = detail;
      movieVideosData = videos;
    });

    _initializeVideoPlayer();

    setState(() => isLoading = false);
  }

  void _initializeVideoPlayer() {
    if (movieVideosData == null ||
        movieVideosData!['results'] == null ||
        movieVideosData!['results'].isEmpty) {
      return;
    }
    print(movieVideosData!['results'][0]['key']);

    final key = movieVideosData!['results'][0]['key'];
    videoUrl = "https://www.youtube.com/watch?v=${key}";

    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = Provider.of<FavoriteMoviesProvider>(context);
    final users = Provider.of<UserProvider>(context);
    final user = users.currentUser;

    if (isLoading || _controller == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(movieData?["original_title"] ?? "Loading..."),
          actions: [
            IconButton(
              onPressed: () {
                final userId = user.userId.toString();
                final isFav = favoriteMovies.isFavorite(userId, widget.idMovie);

                if (isFav) {
                  favoriteMovies.removeFavorite(
                    userId,
                    Movie(
                      movieId: widget.idMovie,
                      title: movieData?['title'],
                      rating: movieData?['vote_average'].toStringAsFixed(2),
                      posterPath: movieData?['poster_path'],
                    ),
                  );
                } else {
                  favoriteMovies.addFavorite(
                    userId,
                    Movie(
                      movieId: widget.idMovie,
                      title: movieData?['title'],
                      rating: movieData?['vote_average'].toStringAsFixed(2),
                      posterPath: movieData?['poster_path'],
                    ),
                  );
                }

                setState(() {});
              },
              icon: Icon(
                favoriteMovies.isFavorite(
                      user!.userId.toString(),
                      widget.idMovie,
                    )
                    ? Icons.bookmark_remove
                    : Icons.bookmark_add,
              ),
            ),
          ],
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: Text(movieData?["original_title"] ?? "Loading..."),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                player,
                const SizedBox(height: 16),
                Text(
                  movieData?['title'] ?? 'Loading...',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  "Rilis: ${movieData?['release_date'] ?? 'Loading...'}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                Text(
                  movieData?['overview'] ?? 'Loading...',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
