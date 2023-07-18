import 'package:firstapp/infrastructure/implementations/getLocationImp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import '../../../domain/location.dart';
import '../../../domain/nota.dart';

class notePreviu {
  String titulo;
  DateTime date;

  notePreviu({required this.titulo,required this.date}); 
}

class homeMapNote {
  List<Nota> notas;
  double latitud;
  double longitud;

  homeMapNote({required this.notas, required this.latitud, required this.longitud});
}



class MyHomeMapScreen extends StatefulWidget {

  List<homeMapNote> notas;
  MyHomeMapScreen({super.key,required this.notas});

  @override
  _MyHomeMapScreenState createState() => _MyHomeMapScreenState(notas: notas);
}

class _MyHomeMapScreenState extends State<MyHomeMapScreen> {

  List<homeMapNote> notas;
  _MyHomeMapScreenState({required this.notas});


  List<location> Locations = [location(latitude: 5, longitude: 4),
  location(latitude: 10, longitude: 15),
  location(latitude: 10, longitude: -60),
  location(latitude: 10, longitude: -60 + 0.0001)
  ];
  bool loading = false;
  String snapshotData = '';
  List<Placemark> placemarks = []; 
  Placemark? placemark;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init()async{
    
  }

  @override
Widget build(BuildContext context) {
  return 
    Scaffold(
    appBar: AppBar(
        title: const Text("ubicacion de la notas"),
        backgroundColor: const Color.fromARGB(255, 99, 91, 250),
        leading: IconButton(
            icon: const Icon(Icons.transit_enterexit_outlined),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
  body:
  loading == true
          ? const Center(
              child: SizedBox(
                  width: 30, height: 30, child: CircularProgressIndicator()))
  :       
  FlutterMap(
    options: MapOptions(
      center: const LatLng(0, 0),
      zoom: 2,
      maxZoom: 18,
      minZoom: 2
    ),
    nonRotatedChildren: [
      RichAttributionWidget(
        attributions: [
          TextSourceAttribution(
            'OpenStreetMap contributors',
            onTap: () => {}//launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
          ),
        ],
      ),
    ],
    children: [
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.example.app',
      ),
    MarkerLayer(
    markers: marcadores()
),
    ],
  )
  
 );
}

List<Marker> marcadores(){
  List<Marker> markers = [];
  for (var element in Locations) {
    markers.add(
      Marker(
      point: LatLng(element.latitude!,element.longitude!),
      width: 80,
      height: 80,
      builder: (context) => IconButton(
                           icon: const Icon(Icons.location_on,color: Colors.red,),
          onPressed: () {
           //showBottomSheet(context: context, builder: (context) => );
          },
       )
      ) 
    );
  }
  return markers;
}



 Widget textLocation() {
    return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
            title: const Text("Nota escrita en:"),
            subtitle:
            Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pais: ${placemark!.country ?? ''}'),
                      Text('Area administrativa: ${placemark!.administrativeArea ?? ''}'),
                      Text('Area subadministrativa: ${placemark!.subAdministrativeArea ?? ''}'),
                      Text('localidad: ${placemark!.locality ?? ''}'),
                      Text('sublocalidad: ${placemark!.subLocality ?? ''}'),
                      Text('via Publica: ${placemark!.thoroughfare ?? ''}'),
                    ],
                  ),
              ),
            ListTile(
            leading: const Icon(Icons.save),
            title: const Text('Guardar ubicacion'),
            onTap: () {
              Navigator.pop(context);
              },
             ),  
            ListTile(
            leading: const Icon(Icons.arrow_back_rounded),
            title: const Text('Regresar'),
            onTap: () {
              Navigator.pop(context);  
              },
             ), 
           ]
          );  

  }




}
