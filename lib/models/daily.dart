class Daily{
  final int dt;
  final double temp;
  final double feelslike;
  final double low;
  final double high; 
  final String description;
  final String pressure;
  final String humidity;
  final String wind;
 // final String icon;

  Daily({required this.dt, required this.temp, required this.feelslike, required this.low, required this.high, required this.description, required this.pressure, required this.humidity, required this.wind, /*required this.icon*/});

  factory Daily.fromJson(Map<String, dynamic> json){
    return Daily(
      dt: json['main']['dt'],
      temp: json['main']['temp'],
      feelslike: json['main']['feels_like'],
      low: json['main']['temp_min'],
      high: json['main']['temp_max'],
      description: json['weather'][0]['description'],
      pressure: json['weather'][0]['pressure'],
      humidity: json['weather'][0]['humidity'],
      wind: json['weather'][0]['wind'],
     // icon: json['weather'][0]['icon'],
    );
  }
}