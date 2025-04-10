import 'dart:convert';
import 'package:http/http.dart' as http;

final token =
    "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlZGU4YjVmMmU3YTU5ZTViOTIxNjFmNDIxYjBiOTRmNSIsIm5iZiI6MTczMDA0MjA4MC42MTAwOTMsInN1YiI6IjY3MWQ1NjNmNGJlMTU0NjllNzBkZjFmYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.CxIF3vbYmKmJ3Kdzzm6VFVJo4cQuGuGRjEKroO_EWec";
final urlPopularMovie = Uri.parse("https://api.themoviedb.org/3/movie/popular");
final urlTopRatedMovie = Uri.parse(
  "https://api.themoviedb.org/3/movie/top_rated",
);
final urlUpcomingMovie = Uri.parse(
  "https://api.themoviedb.org/3/movie/upcoming",
);
final urlMovieDetail = Uri.parse("https://api.themoviedb.org/3/movie/");
final headers = {
  'Authorization': 'Bearer $token',
  'Content-Type': 'application/json',
};

Future<dynamic> getPopularMovies() async {
  try {
    final response = await http.get(urlPopularMovie, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      print('Status Code: ${response.statusCode}');
      print('Error Response: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error : $e');
    return null;
  }
}

Future<dynamic> getTopRatedMovies() async {
  try {
    final response = await http.get(urlTopRatedMovie, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      print('Status Code: ${response.statusCode}');
      print('Error Response: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error : $e');
    return null;
  }
}

Future<dynamic> getUpcomingMovies() async {
  try {
    final response = await http.get(urlUpcomingMovie, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      print('Status Code: ${response.statusCode}');
      print('Error Response: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error : $e');
    return null;
  }
}

Future<dynamic> getDetailMovie(movieId) async {
  try {
    final response = await http.get(urlMovieDetail, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      print('Status Code: ${response.statusCode}');
      print('Error Response: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error : $e');
    return null;
  }
}

const String imageBaseUrl = "https://image.tmdb.org/t/p/";
String getImageUrl(String path, {String size = "w500"}) {
  return "$imageBaseUrl$size$path";
}
