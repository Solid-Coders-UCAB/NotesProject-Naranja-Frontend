import 'package:firstapp/infrastructure/views/noteWidgets/notePreview.dart';
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


  bool loading = false;
  String snapshotData = '';
  List<Placemark> placemarks = []; 
  Placemark? placemark;

  @override
  void initState() {
    super.initState();
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
  for (var element in notas) {
    markers.add(
      Marker(
      point: LatLng(element.latitud,element.longitud),
      width: 80,
      height: 80,
      builder: (context) => IconButton(
                           icon: const Icon(Icons.location_on,color: Colors.red,),
          onPressed: () {
            showBottomSheet(context: context, builder: (context) => textLocation(homeMapNotes: element));
          },
       )
      ) 
    );
  }
  return markers;
}

}


class textLocation extends StatefulWidget{

  homeMapNote homeMapNotes;

  textLocation({super.key,required this.homeMapNotes});

  @override
  State<textLocation> createState() => textLocationState(homeMapNotes: homeMapNotes);

}

class textLocationState extends State<textLocation> {

  homeMapNote homeMapNotes;
  Placemark? placemark;
  bool loading = false;

  @override
  void initState() {
    super.initState();
     setState(() {
       loading = true;
     });
     init();
  }

  void init() async {
    var placemarks = await placemarkFromCoordinates(homeMapNotes.latitud,homeMapNotes.longitud);
      placemark = placemarks.first;
      setState(() {
        loading = false;
      });  

  }


  textLocationState({required this.homeMapNotes});
  
  @override
  Widget build(BuildContext context) {
    return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
            title: const Text("Nota(s) escrita(s) en:"),
            subtitle:
            loading == true
          ? const Center(
              child: SizedBox(
                  width: 30, height: 30, child: CircularProgressIndicator()))
          : 
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
            ListView.builder(
              itemCount: homeMapNotes.notas.length,
              itemBuilder: (context, index) {
                return notePreviewWidget(nota: homeMapNotes.notas[index]);
              },
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
            ),
           ]
          ); 
  }

}
  
