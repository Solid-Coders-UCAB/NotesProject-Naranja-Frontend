import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Location'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String locationMessage = 'Current location of the user';
  late String latitude;
  late String longitude;
  late String addressName;
  late String addressCountry;
  late String addressArea;
  late String addressSubArea;
  late String addressLocality;

  //Get current location--------------------------------
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Los servicios de ubicación no está habilitados');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Los permisos de ubicación rechazados');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Los permisos de ubicación rechazados permanentemente, no podemos encontrar su ');
    }
    return await Geolocator.getCurrentPosition();
  }

//----------------Get address---------------------------
  Future<void> _updatePosition() async {
    Position position = await _getCurrentLocation();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
      addressName = placemarks[0].name.toString();
      addressCountry = placemarks[0].country.toString();
      addressArea = placemarks[0].administrativeArea.toString();
      addressSubArea = placemarks[0].subAdministrativeArea.toString();
      addressLocality = placemarks[0].locality.toString();
    });
  }

  //Listen to location updates -----------------------
  //Este se puede quitar
  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
      setState(() {
        locationMessage = 'Latitude: $latitude, Longitude: $longitude';
      });
    });
  }

  //Abrir la ubicación en Google Maps
  // Future<void> _openMap(String lat, String long) async {
  //   String googleURL =
  //       'https://www.google.com/maps/search/?api=1&query=$lat,$long';
  //   await canLaunchUrlString(googleURL)
  //       ? await launchUrlString(googleURL)
  //       : throw 'could not launch';
  // }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              locationMessage,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  _updatePosition();
                  setState(() {
                    locationMessage =
                        'Latitude: $latitude, Longitude: $longitude, Name: $addressName, Country: $addressCountry, Administrative area: $addressArea, Subaministrative area: $addressSubArea, Locality: $addressLocality';
                  });
                },
                child: const Text('Get current location')),
            const SizedBox(
              height: 20,
            ),
            // ElevatedButton(
            //     onPressed: () {
            //       _openMap(latitude, longitude);
            //     },
            //     child: const Text('Abrir Google Maps'))
          ],
        ),
      ),
    );
  }
}
