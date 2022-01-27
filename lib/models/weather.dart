class Weather{
 // final double dt;
  final double temp;
  final double feelslike;
  final double low;
  final double high; 
  final String description;
  final int pressure;
  final int humidity;
  //final String wind;
  final String icon;
  final String name;
  final double wind;

  Weather({required this.name, required this.wind, required this.temp, required this.feelslike, required this.low, required this.high, required this.description, required this.pressure, required this.humidity,/* required this.wind,*/ required this.icon});

  factory Weather.fromJson(Map<String, dynamic> json){
    return Weather(
      name: json['name'],
      wind: json['wind']['speed'],
      temp: json['main']['temp'],
      feelslike: json['main']['feels_like'],
      low: json['main']['temp_min'],
      high: json['main']['temp_max'],
      description: json['weather'][0]['description'],
      pressure: json['main']['pressure'],
      humidity: json['main']['humidity'],
    //  wind: json['weather'][0]['wind'],
      icon: json['weather'][0]['icon'],
    );
    }
}


// Second page
