/*import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meteo/models/weather.dart';
import 'package:meteo/currentWeather.dart';


Future<Weather> fetchWeather() async {
  var apiKey= "ed60fcfbd110ee65c7150605ea8aceea";
  var city ="Abidjan";
  final response = await http
      .get(Uri.parse('http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Weather.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}*/
