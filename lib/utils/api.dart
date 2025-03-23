import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<dynamic> getMoviesByType() async {

  // final url = Uri.parse("${dotenv.env['BASE_URL']}/discover/movie");
  // final token = dotenv.env['API_TOKEN'];

  // IF DEBUGING WITH WEB
  final url = Uri.parse("https://api.themoviedb.org/3/discover/movie");
  final token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlZGU4YjVmMmU3YTU5ZTViOTIxNjFmNDIxYjBiOTRmNSIsIm5iZiI6MTczMDA0MjA4MC42MTAwOTMsInN1YiI6IjY3MWQ1NjNmNGJlMTU0NjllNzBkZjFmYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.CxIF3vbYmKmJ3Kdzzm6VFVJo4cQuGuGRjEKroO_EWec";

  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  };
  

  try {
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final preetyJson = const JsonEncoder.withIndent(" ").convert(data);
      print("Berhasil Fetch Data: $preetyJson");

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
