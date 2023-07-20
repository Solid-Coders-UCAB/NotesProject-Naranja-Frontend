import 'package:flutter/material.dart';
import '../../../domain/folder.dart';
import '../../controllers/homeFolderController.dart';
import '../systemWidgets/navigationBar.dart';
import 'package:firstapp/controllerFactory.dart';
import 'package:firstapp/infrastructure/views/folderWidgets/carpeta_nueva.dart';
import 'notas_en_carpeta.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/textEditor.dart';

// Ventana que muestra todas las carpetas del usuario
class folderHome extends StatefulWidget {
  const folderHome({super.key});

  @override
  folderHomeState createState() => folderHomeState();
}

class folderHomeState extends State<folderHome> {
  folderHomeState();

  bool loading = false;
  List<folder> folders = <folder>[];
  List<String> foldersNombre = [];
  final TextEditingController buscarNota = TextEditingController(text: '');

  // Se crea un controlador con la logica de la ventana HomeFolderController
  homeFolderController controller = controllerFactory.homefolderController();

  void changeState(List<folder> f) {
    setState(() {
      loading = false;
      folders = f;
      for (var element in f) {
        foldersNombre.add(element.name);
      }
    });
  }

  void showSystemMessage(String? message) {
    setState(() {
      loading = false;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message!)));
  }

  @override
  void initState() {
    super.initState();
    controller.getAllFolders(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 30, 103, 240),
          title: const Text("Carpetas"),
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
        ),
        //Side menu------------------------------
        drawer: NavBar(),
        // Boton para crear una nota
        floatingActionButton: Container(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 30, 103, 240),
            // Al tocar este boton se abre la ventana para crear una nota en la carpeta por defecto
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HtmlEditorExampleApp()));
            },
            heroTag: 'addButton',
            child: const Icon(Icons.add),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: loading == true
            ? const Center(
                child: SizedBox(
                    width: 30, height: 30, child: CircularProgressIndicator()))
            : listaCarpetas());
  }

// Lista con los nombres de las carpetas del usuario
  Widget listaCarpetas() {
    return ListView.builder(
      itemCount: folders.length + 1,
      itemBuilder: (context, index) {
        if (index == folders.length) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CarpetaNueva(foldersNombre: foldersNombre,)));
            },
            child: const Card(
                child: Material(
                    child: ListTile(
              title: Text("agregar nueva carpeta"),
              leading: Icon(Icons.plus_one),
            ))),
          );
        }
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotasEnCarpeta(
                          nombreCarpeta: folders[index].name,
                          idCarpeta: folders[index].id.toString(),
                          foldersNombre: foldersNombre,
                        )));
          },
          child: (Card(
              child: Material(
            child: ListTile(
              title: Text(folders[index].name),
              leading: const Icon(Icons.folder),
            ),
          ))),
        );
      },
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
    );
  }

  void reset() {
    setState(() {
      loading = false;
    });
  }

  void setLoadingState(bool l) {
    setState(() {
      loading = l;
    });
  }
}

class MyListWidget extends StatelessWidget {
  final List<String> cosas = ['Cosas 1', 'Cosas 2', 'Cosas 3'];

  MyListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView.builder(
        itemCount: cosas.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(cosas[index]),
          );
        },
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
      ),
    );
  }
}
