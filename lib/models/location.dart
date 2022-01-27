class Location{
  final String city;
  final String country;
  final String lat;
  final String lon;

  Location({required this.city, required this.country, required this.lat, required this.lon});

  factory Location.fromJson(Map<String, dynamic> json){
    return Location(
      city: json['main']['city'],
      country: json['main']['country'],
      lat: json['main']['lat'],
      lon: json['main']['lon'],
    );
  }
}