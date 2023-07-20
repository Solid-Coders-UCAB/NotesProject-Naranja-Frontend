import 'package:firstapp/infrastructure/implementations/getLocationImp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import '../../../domain/location.dart';


class MyMapScreen extends StatefulWidget {
  @override
  _MyMapScreenState createState() => _MyMapScreenState();
}

class _MyMapScreenState extends State<MyMapScreen> {

  location? currentLocation;
  bool loading = false;
  String snapshotData = '';
  List<Placemark> placemarks = []; 
  Placemark? placemark;

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    init();
  }

  void init()async{
    var locationResponse = await GetLocationImp().getCurrentLocation();
      if (locationResponse.isRight){
        currentLocation = locationResponse.right;
      }else{
        print(locationResponse.left.message);
      }
      placemarks = await placemarkFromCoordinates(currentLocation!.latitude!,currentLocation!.longitude!);
      placemark = placemarks.first;
      setState(() {
        loading = false;
      });  
  }

  @override
Widget build(BuildContext context) {
  return 
    Scaffold(
    appBar: AppBar(
        title: const Text("ubicacion de la nota"),
        backgroundColor: const Color.fromARGB(255, 99, 91, 250),
        leading: IconButton(
            icon: const Icon(Icons.close),
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
      center: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
      zoom: 13,
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
    markers: [
    Marker(
      point: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
      width: 80,
      height: 80,
      builder: (context) => IconButton(
                           icon: const Icon(Icons.location_on,color: Colors.red,),
          onPressed: () {
           showBottomSheet(context: context, builder: (context) => textLocation());
          },
      )
    ),
  ],
),
    ],
  )
  
 );
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
              Navigator.pop(context,currentLocation);  
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
