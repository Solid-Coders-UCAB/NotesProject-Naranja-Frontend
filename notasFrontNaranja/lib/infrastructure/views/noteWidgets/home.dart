import 'package:firstapp/controllerFactory.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/infrastructure/controllers/homeController.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/map%20copy.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/textEditor.dart';
import 'package:flutter/material.dart';
import 'notePreview.dart';
import 'package:firstapp/infrastructure/views/systemWidgets/navigationBar.dart';
import 'package:firstapp/infrastructure/views/filterWidgets/searchNotaDelegate.dart';

// Pagina principal donde se muestran todas las notas de un usuario
class PaginaPrincipal extends StatelessWidget {
  const PaginaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notas',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({super.key});

  @override
  homeState createState() => homeState();
}

class homeState extends State<Home> {
  homeState();

  bool loading = false;
  List<Nota> notas = <Nota>[];

  // Se asigna el controlador con la logica de la ventana Home
  homeController controller = controllerFactory.createHomeController();

  @override
  void initState() {
    super.initState();
    showNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 103, 240),
        title: const Text("Notas"),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: 'Menú',
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: searchNotaDelegate());
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      //Side menu------------------------------
      drawer: const NavBar(),

      //  Boton para crear una nota
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 99, 91, 250),
          onPressed: () async {
            createNote();
          },
          heroTag: 'addButton',
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      bottomNavigationBar: 
        FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 99, 91, 250),
          onPressed: () async {
           /* Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyHomeMapScreen()));
           */
            filtrarNotasForMap(); 
          },
          heroTag: 'mapButton',
          child: const Icon(Icons.map),
        ),


      body: loading == true
          ? const Center(
              child: SizedBox(
                  width: 30, height: 30, child: CircularProgressIndicator()))
          : ListView.builder(
              itemCount: notas.length,
              itemBuilder: (context, index) {
                return notePreview(notas[index]);
              },
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
            ),
    );
  }

  void reset() {
    setState(() {
      loading = true;
    });
  }

  void setLoadingState() {
    setState(() {
      loading = true;
    });
  }

  void showNotes() async {
    controller.getAllNotesFromServer(this);
  }

  void showSystemMessage(String? message) {
    setState(() {
      loading = false;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message!)));
  }

  void createNote() async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => HtmlEditorExampleApp()));
  }

  Widget notePreview(Nota note) {
    return (notePreviewWidget(
        nota: note));
  
  }


void filtrarNotasForMap() {
    List<Nota> auxNotas = [];
        for (var note in notas){
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
          tareas: note.tareas
          ));
        }
    print('paso');
    auxNotas.removeWhere((element) => element.latitud == null && element.longitud == null);
    print(auxNotas.length);
    auxNotas.forEach((element) { print('auxNotas:${element.titulo}');});
    notas.forEach((element) { print('Notas:${element.id}');});
    List<homeMapNote> mapNotes = [];

    int cont = 0;

  
     for (var note in auxNotas) {
      if (note.id != ''){
       List<Nota> previews = [];
       for (var note2 in auxNotas){
          if (note2.latitud == note.latitud && note2.longitud == note.longitud  && (note.id != note2.id) && (note2.id != '')) {

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
                tareas: note2.tareas
              );
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
                tareas: note.tareas
              );
       previews.add(auxNote);
       previews.forEach((element) { print('notasPre[${cont}]${element.titulo}');});
       cont++;
        //auxNotas.remove(note);
        note.id = '';
       mapNotes.add(homeMapNote(notas: previews, latitud: note.latitud!, longitud: note.longitud!));
      }
     } 

      mapNotes.forEach((element) {print('${element.longitud},${element.latitud}');});

        if (mapNotes.isEmpty){
          showSystemMessage('no posee notas con localizacion para usar esta opcion, para agregar localizacion cree una nota y pulse el boton de +');
        }else{
              Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => MyHomeMapScreen(notas: mapNotes)));
        }

      
   }

}

