import 'dart:convert';
import 'dart:ffi';
//import 'dart:js';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meteo/extensions.dart';
import 'package:meteo/models/forecast.dart';
import 'package:meteo/models/location.dart';
import 'package:meteo/models/weather.dart';
import 'package:meteo/api/weatherApi.dart';

import 'models/hourly.dart';

class CurrentWeather extends StatefulWidget {
  final String city;
  final String lon;
  final String lat;
  CurrentWeather({ required this.city, required this.lon, required this.lat }) ;

  @override
  _CurrentWeatherState createState() => _CurrentWeatherState();
}



class _CurrentWeatherState extends State<CurrentWeather> {
  
  late Future<Weather> futureWeather;
  late Future<Hourly> futureHourly;
  Future<Weather> fetchWeather() async {
  var apiKey= "ed60fcfbd110ee65c7150605ea8aceea";
  var  city = widget.city;
  final response = await http
      .get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&lang=en&units=metric'));
  
 /* final response2 = await http
      .get(Uri.parse('pro.openweathermap.org/data/2.5/forecast/hourly?q=$city&appid=$apiKey'));
*/
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Weather.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
 // second
  Future<Hourly> fetchHourly() async {
  var apiKey= "ed60fcfbd110ee65c7150605ea8aceea";
  var  city = widget.city;
  var  lon = widget.lon;
  var  lat = widget.lat;
  final response = await http
      .get(Uri.parse('https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&appid=$apiKey&units=metric'));
  
 /* final response2 = await http
      .get(Uri.parse('pro.openweathermap.org/data/2.5/forecast/hourly?q=$city&appid=$apiKey'));
*/
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Hourly.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

  @override
  void initState(){
    super.initState();
    futureWeather = fetchWeather();
    futureHourly = fetchHourly();
  }

  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ( Column(children: [
      Center(
        child: FutureBuilder<Weather>(
          future: futureWeather,
          builder: (context, alb){
              if (alb.hasData){
                return Column(
                  
                  mainAxisSize: MainAxisSize.min,
                  children: [
// CITY NAME
                    Container(
    padding: const EdgeInsets.only(left: 20, top: 15, bottom: 15, right: 20),
    margin: const EdgeInsets.only(top: 35, left: 15.0, bottom: 15.0, right: 15.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(60)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3),
        )
      ]
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: alb.data!.name.toString(),
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
        Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.black,
          size: 24.0,
          semanticLabel: 'Tap to change location',
        ),
      ],
    )
  ),

// SUPPORT + ICON
                Stack( children: [
                  Container(
      padding: const EdgeInsets.all(15.0),
      margin: const EdgeInsets.all(15.0),
      height: 160.0,
      decoration: BoxDecoration(
          color: Colors.indigoAccent,
          borderRadius: BorderRadius.all(Radius.circular(20))),
    ),
     ClipPath(
        clipper: Clipper(),
        child: Container(
            padding: const EdgeInsets.all(15.0),
            margin: const EdgeInsets.all(15.0),
            height: 160.0,
            decoration: BoxDecoration(
                color: Colors.indigoAccent[400],
                borderRadius: BorderRadius.all(Radius.circular(20))))),
                   Container(
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.all(15.0),
        height: 160.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Row(
          children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                  getWeatherIcon(alb.data!.icon),
                  Container(
                      margin: const EdgeInsets.all(5.0),
                      child: Text(alb.data!.description.capitalizeFirstOfEach,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.white),
                      )),
                  Container(
                      margin: const EdgeInsets.all(5.0),
                      child: Text(
                        "H: "+ alb.data!.high.toString()+" ° L:" +alb.data!.low.toString()+" ° ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 13,
                            color: Colors.white),
                      )),
                ])),
            Column(children: <Widget>[
              Container(
                child: Text(alb.data!.temp.toString()+"°",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 60,
                      color: Colors.white),
              )
              ),
              Container(
                  margin: const EdgeInsets.all(0),
                  child: Text(
                    "Feels like: "+ alb.data!.feelslike.toString()+ " °",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        color: Colors.white),
                  )),
            ])
          ],
        )), ]),

// HUMIDITY, PRESSURE, WIND                    
                    Container(
    padding: const EdgeInsets.only(left: 15, top: 25, bottom: 25, right: 15),
    margin: const EdgeInsets.only(left: 15, top: 5, bottom: 15, right: 15),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          )
        ]),
    child: Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                  child: Text(
                "Wind",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.grey),
              )),
              Container(
                  child: Text(alb.data!.wind.toString()+" km/h",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.black),
              ))
            ],
          )
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                  child: Text(
                "Humidity",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.grey),
              )),
              Container(
                  child: Text(alb.data!.humidity.toString()+" %",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.black),
              ))
            ],
          )
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                  child: Text(
                "Pressure",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.grey),
              )),
              Container(
                  child: Text(alb.data!.pressure.toString()+" hPa",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.black),
              ))
            ],
          )
        )
      ],
    ),
  ),


        /*     Container(
      margin: EdgeInsets.symmetric(vertical: 0.0),
      height: 150.0,
      child: ListView.builder(
          padding: const EdgeInsets.only(left: 8, top: 0, bottom: 0, right: 8),
          scrollDirection: Axis.horizontal,
          itemCount: _forecast.hourly.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: const EdgeInsets.only(
                left: 10, top: 15, bottom: 15, right: 10),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 1), // changes position of shadow
                      )
                    ]),
                child: Column(children: [
                  Text(hourly,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        color: Colors.black),
                  ),
                  getWeatherIcon(_forecast.hourly[index].icon),
                  Text(
                    "${getTimeFromTimestamp(_forecast.hourly[index].dt)}",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.grey),
                  ),
                ]));
          })) */
                   /* Container(
                      margin: EdgeInsets.all(10),
                      child:  Text(alb.data!.temp.toString()+"°C",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50)
                              ,),
                    )
               
                    Container(
                      margin: EdgeInsets.all(5),
                      child:  Text(alb.data!.description),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child:  Text(alb.data!.pressure.toString()),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child:  Text(alb.data!.icon),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child:  Text(alb.data!.humidity.toString()),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child:  Text("Feels:"+alb.data!.feelslike.toString()+"°C"),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child:  Text("H:"+alb.data!.high.toString()+"°C"+" L:"+alb.data!.low.toString()+"°C"),
                    ),
                   /* Container(
                      margin: EdgeInsets.all(5),
                      child:  Text("L:"+alb.data!.low.toString()+"°C"),
                    )*/
                    
                   
                   /* Text(alb.data!.description),
                    Text("Feels:"+alb.data!.feelslike.toString()+"°C"),
                    Text("H:"+alb.data!.high.toString()+"°C"),
                    Text("L:"+alb.data!.low.toString()+"°C"),*/
                  /*  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          futureWeather = deleteAlbum(alb.data!.id.toString());
                        });
                      }, 
                      child: Text('Supprimer'),
                      )*/*/
                  
          /* Center(
            child:  Image.asset('assets/pic1.jpg',
            width: 490,
            height: 1200,
            fit: BoxFit.fill),
          ),*/
          ],
                );
              }else if(alb.hasData){
                return Text('${alb.error}');
              }
              return const CircularProgressIndicator();
          },
        ),
        
        ),

        //FORECAST DISPLAYING
        Center(
          child: FutureBuilder<Hourly>(
          future: futureHourly,
          builder: (context, snap){
              if (snap.hasData){
                return Column(
                  
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
      margin: EdgeInsets.symmetric(vertical: 0.0),
      height: 150.0,
      child: ListView.builder(
          padding: const EdgeInsets.only(left: 8, top: 0, bottom: 0, right: 8),
          scrollDirection: Axis.horizontal,
         // itemCount: _forecast.hourly.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: const EdgeInsets.only(
                left: 10, top: 15, bottom: 15, right: 10),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 1), // changes position of shadow
                      )
                    ]),
                child: Column(children: [
                  Text(snap.data!.temp.toString()+'°',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        color: Colors.black),
                  ),
                  getWeatherIcon(snap.data!.icon.toString()),
                  Text(snap.data!.description.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.grey),
                  ),
                ])
                );
          })),
                  ]
                  
        );
              }else if(snap.hasData){
                return Text('${snap.error}');
              }
              return const CircularProgressIndicator();
          },
          
              )
        ),
        
        
        ]
              ,)
       // child: FutureBuilder<Forecast>()
      
    ),
    );
  }
}

// second page
class CityList extends StatelessWidget {
  const CityList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     /* appBar: AppBar(
        title: const Text('List of cities',
        style: TextStyle(
          color: Color(0xffF5591F),
        ),),
      ),*/
      body: Column(children: [Container(
              height: 80,
              decoration: BoxDecoration(
                //borderRadius: BorderRadius.only(bottomLeft: Radius.circular(120)),
                gradient: LinearGradient(
                  colors: [(new Color(0xffF5591F)), (new Color(0xffF5591F))],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
                )
              ),
              child: Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 /* Container(
                    margin: EdgeInsets.only(top: 50),
                    //child: Image.asset(name),
                    height: 30,
                    width: 30,),*/

                    Container(
                      margin: EdgeInsets.only(right: 20, top: 20),
                      alignment: Alignment.center,
                      child: Text(
                        "List of Cities",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white
                        ),
                      ),)
                ],),
              ),
              ),



        Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 200),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.center,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [(new Color(0xffF5591f)), (new Color(0xffF2861E))],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight
                    ),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: Color(0xffEEEEEE),
                      
                    )],
                  ),
                  
        
       // Center(
          
           child: TextButton(
           onPressed: () {

             
             
             
            // Navigate back to first route when tapped.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  CurrentWeather(city: 'Abidjan',lon : '-4.0197', lat: '5.3094')),
            );
          },
          child: const Text('Abidjan',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white

          ),),
        ),),

        Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.center,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [(new Color(0xffF5591f)), (new Color(0xffF2861E))],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight
                    ),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: Color(0xffEEEEEE)
                    )],
                  ),
        child : TextButton(
           onPressed: () {
            // Navigate back to first route when tapped.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  CurrentWeather(city: 'Paris',lon: '2.3488', lat: '48.8534')),
            );},
          child: const Text('Paris',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white

          ),),
        ),
        ),
        
        Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.center,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [(new Color(0xffF5591f)), (new Color(0xffF2861E))],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight
                    ),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: Color(0xffEEEEEE)
                    )],
                  ),
        child :TextButton(
           onPressed: () {
            // Navigate back to first route when tapped.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CurrentWeather(city: 'Bruxelles',lon: '4.3488', lat: '50.8504')),
            );
          },
          child: const Text('Bruxelles',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white

          ), ),
          ),
       ) ],)
    );
  }
}



Widget createAppBar() {
  var alb;
  return Container(
    padding: const EdgeInsets.only(left: 20, top: 15, bottom: 15, right: 20),
    margin: const EdgeInsets.only(top: 35, left: 15.0, bottom: 15.0, right: 15.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(60)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3),
        )
      ]
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: (alb.data!.name.toString()),
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
        Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.black,
          size: 24.0,
          semanticLabel: 'Tap to change location',
        ),
      ],
    )
  );
}


// IMAGE
Image getWeatherIcon(String _icon) {
  String path = 'assets/';
  String imageExtension = ".png";
  return Image.asset(
    path + _icon + imageExtension,
    width: 70,
    height: 70,
  );
}

Image getWeatherIconSmall(String _icon) {
  String path = 'assets/';
  String imageExtension = ".png";
  return Image.asset(
    path + _icon + imageExtension,
    width: 40,
    height: 40,
  );
}


class Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height - 20);

    path.quadraticBezierTo((size.width / 6) * 1, (size.height / 2) + 15,
        (size.width / 3) * 1, size.height - 30);
    path.quadraticBezierTo((size.width / 2) * 1, (size.height + 0),
        (size.width / 3) * 2, (size.height / 4) * 3);
    path.quadraticBezierTo((size.width / 6) * 5, (size.height / 2) - 20,
        size.width, size.height - 60);

    path.lineTo(size.width, size.height - 60);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    
    path.close();

    return path;
  }

  @override
  bool shouldReclip(Clipper oldClipper) => false;
}

String getTimeFromTimestamp(int timestamp) {
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var formatter = new DateFormat('h:mm a');
  return formatter.format(date);
}

String getDateFromTimestamp(int timestamp) {
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var formatter = new DateFormat('E');
  return formatter.format(date);
}
