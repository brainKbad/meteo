import 'package:meteo/models/daily.dart';
import 'package:meteo/models/hourly.dart';

class Forecast {
  final List<Hourly> hourly;
  final List<Daily> daily;

  Forecast({required this.hourly, required this.daily});
  
  factory Forecast.fromJson(Map<String, dynamic> json){
    List<dynamic> hourlyData = json['hourly'];
    List<dynamic> dailylyData = json['daily'];

    List<Hourly> hourly = [];
    List<Daily> daily = [];

    hourlyData.forEach((item) {
      var hour = Hourly.fromJson(item);
      hourly.add(hour);
     });
    
    dailylyData.forEach((item) {
      var hour = Daily.fromJson(item);
      daily.add(hour);
     });


     return Forecast(
       hourly: hourly,
       daily: daily
     );
  }
}