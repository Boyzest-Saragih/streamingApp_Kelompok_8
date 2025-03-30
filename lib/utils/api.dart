import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

  // final url = Uri.parse("${dotenv.env['BASE_URL']}/discover/movie");
  // final token = dotenv.env['API_TOKEN'];

  // IF DEBUGING WITH WEB
final token =
    "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlZGU4YjVmMmU3YTU5ZTViOTIxNjFmNDIxYjBiOTRmNSIsIm5iZiI6MTczMDA0MjA4MC42MTAwOTMsInN1YiI6IjY3MWQ1NjNmNGJlMTU0NjllNzBkZjFmYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.CxIF3vbYmKmJ3Kdzzm6VFVJo4cQuGuGRjEKroO_EWec";
final urlPopularMovie = Uri.parse("https://api.themoviedb.org/3/movie/popular");
final urlTopRatedMovie = Uri.parse("https://api.themoviedb.org/3/movie/top_rated");
final urlUpcomingMovie = Uri.parse("https://api.themoviedb.org/3/movie/upcoming");
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
      print('Gagal memuat data: ${response.statusCode}');
      print('Response: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error Exception: $e');
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
      print('Gagal memuat data: ${response.statusCode}');
      print('Response: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error Exception: $e');
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
      print('Gagal memuat data: ${response.statusCode}');
      print('Response: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error Exception: $e');
    return null;
  }
}

const String imageBaseUrl = "https://image.tmdb.org/t/p/";
String getImageUrl(String path, {String size = "w500"}) {
  return "$imageBaseUrl$size$path";
}
