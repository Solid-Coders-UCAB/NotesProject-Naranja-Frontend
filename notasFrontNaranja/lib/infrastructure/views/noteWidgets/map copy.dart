import 'package:firstapp/application/getAllNotEliminatedNotesFromServerService.dart';
import 'package:firstapp/infrastructure/implementations/repositories/HTTPnoteRepositoy.dart';
import 'package:firstapp/infrastructure/implementations/repositories/localUserRepository.dart';
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

  notePreviu({required this.titulo, required this.date});
}

class homeMapNote {
  List<Nota> notas;
  double latitud;
  double longitud;

  homeMapNote(
      {required this.notas, required this.latitud, required this.longitud});
}

class MyHomeMapScreen extends StatefulWidget {
  MyHomeMapScreen({super.key});

  @override
  _MyHomeMapScreenState createState() => _MyHomeMapScreenState();
}

class _MyHomeMapScreenState extends State<MyHomeMapScreen> {
  List<homeMapNote> notas = [];

  _MyHomeMapScreenState();

  bool loading = false;
  String error = '';
  String snapshotData = '';
  List<Placemark> placemarks = [];
  Placemark? placemark;
  getAllNotEliminatedNotesFromServerService getAllNotesService =
      getAllNotEliminatedNotesFromServerService(
          noteRepo: httpNoteRepository(), localUserRepo: localUserRepository());

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    init();
  }

  void init() async {
    var notasRes = await getAllNotesService.execute(null);
    if (notasRes.isLeft) {
      setState(() {
        loading = false;
        error = notasRes.left.message!;
      });
    } else {
      List<Nota> auxNotas = [];
      List<Nota> notas = notasRes.right;
      for (var note in notas) {
        auxNotas.add(Nota(
            n_date: note.n_date,
            n_edit_date: note.n_edit_date,
            contenido: note.contenido,
            titulo: note.titulo,
            id: note.id,
            idCarpeta: note.idCarpeta,
            longitud: note.longitud,
            latitud: note.latitud,
            etiquetas: note.etiquetas,
            estado: note.estado,
            tareas: []));
      }
      print('paso');
      auxNotas.removeWhere(
          (element) => element.latitud == null && element.longitud == null);
      print(auxNotas.length);
      auxNotas.forEach((element) {
        print('auxNotas:${element.titulo}');
      });
      notas.forEach((element) {
        print('Notas:${element.id}');
      });
      List<homeMapNote> mapNotes = [];
      int cont = 0;
      for (var note in auxNotas) {
        if (note.id != '') {
          List<Nota> previews = [];
          for (var note2 in auxNotas) {
            if (note2.latitud == note.latitud &&
                note2.longitud == note.longitud &&
                (note.id != note2.id) &&
                (note2.id != '')) {
              var auxNote = Nota(
                  n_date: note2.n_date,
                  n_edit_date: note2.n_edit_date,
                  contenido: note2.contenido,
                  titulo: note2.titulo,
                  id: note2.id,
                  idCarpeta: note2.idCarpeta,
                  longitud: note2.longitud,
                  latitud: note2.latitud,
                  etiquetas: note2.etiquetas,
                  estado: note2.estado,
                  tareas: []);
              previews.add(auxNote);
              //auxNotas.remove(note2);
              note2.id = '';
            }
          }
          var auxNote = Nota(
              n_date: note.n_date,
              n_edit_date: note.n_edit_date,
              contenido: note.contenido,
              titulo: note.titulo,
              id: note.id,
              idCarpeta: note.idCarpeta,
              longitud: note.longitud,
              latitud: note.latitud,
              etiquetas: note.etiquetas,
              estado: note.estado,
              tareas: []);
          previews.add(auxNote);
          previews.forEach((element) {
            print('notasPre[${cont}]${element.titulo}');
          });
          cont++;
          //auxNotas.remove(note);
          note.id = '';
          mapNotes.add(homeMapNote(
              notas: previews,
              latitud: note.latitud!,
              longitud: note.longitud!));
        }
      }

      mapNotes.forEach((element) {
        print('${element.longitud},${element.latitud}');
      });

      if (mapNotes.isEmpty) {
        setState(() {
          loading = false;
          error =
              'no posee notas con localizacion para usar esta opcion, para agregar localizacion cree una nota y pulse el boton de +';
        });
      } else {
        setState(() {
          loading = false;
          this.notas = mapNotes;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notas con ubicación"),
          backgroundColor: const Color.fromARGB(255, 30, 103, 240),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: loading == true
            ? const Center(
                child: SizedBox(
                    width: 30, height: 30, child: CircularProgressIndicator()))
            : error != ''
                ? Center(child: Text(error))
                : FlutterMap(
                    options: MapOptions(
                        center: const LatLng(0, 0),
                        zoom: 2,
                        maxZoom: 18,
                        minZoom: 2),
                    nonRotatedChildren: [
                      RichAttributionWidget(
                        attributions: [
                          TextSourceAttribution('OpenStreetMap contributors',
                              onTap: () =>
                                  {} //launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                              ),
                        ],
                      ),
                    ],
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(markers: marcadores()),
                    ],
                  ));
  }

  List<Marker> marcadores() {
    List<Marker> markers = [];
    for (var element in notas) {
      markers.add(Marker(
          point: LatLng(element.latitud, element.longitud),
          width: 80,
          height: 80,
          builder: (context) => IconButton(
                icon: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
                onPressed: () {
                  showBottomSheet(
                      context: context,
                      builder: (context) =>
                          textLocation(homeMapNotes: element));
                },
              )));
    }
    return markers;
  }
}

class textLocation extends StatefulWidget {
  homeMapNote homeMapNotes;

  textLocation({super.key, required this.homeMapNotes});

  @override
  State<textLocation> createState() =>
      textLocationState(homeMapNotes: homeMapNotes);
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
    var placemarks = await placemarkFromCoordinates(
        homeMapNotes.latitud, homeMapNotes.longitud);
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
            subtitle: loading == true
                ? const Center(
                    child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator()))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pais: ${placemark!.country ?? ''}'),
                      Text(
                          'Area administrativa: ${placemark!.administrativeArea ?? ''}'),
                      Text(
                          'Area subadministrativa: ${placemark!.subAdministrativeArea ?? ''}'),
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
        ]);
  }
}
