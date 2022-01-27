class Hourly{
  final int dt;
  final double temp;
  /*final double feelslike;*/
  final double low;
  final double high; 
  final int description;
  /*final String pressure;
  final String humidity;
  final String wind;*/
  final String icon;

  Hourly({required this.dt, required this.temp,/* required this.feelslike,*/ required this.low, required this.high, required this.description,/* required this.pressure, required this.humidity, required this.wind,*/ required this.icon});

  factory Hourly.fromJson(Map<String, dynamic> json){
    return Hourly(
      dt: json['hourly'][0]['dt'],
      temp: json['hourly'][0]['temp'],
   /*   feelslike: json['main']['feels_like'],*/
      low: json['daily'][0]['temp']['min'],
      high: json['daily'][0]['temp']['max'],
      description: json['hourly'][0]['humidity'],
    /*  pressure: json['weather'][0]['pressure'],
      humidity: json['weather'][0]['humidity'],
      wind: json['weather'][0]['wind'],*/
      icon: json['hourly'][0]['weather'][0]['icon'],
    );
  }
}