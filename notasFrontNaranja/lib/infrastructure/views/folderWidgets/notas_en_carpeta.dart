import 'package:flutter/material.dart';
import 'package:firstapp/infrastructure/views/folderWidgets/editar_carpeta.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/infrastructure/controllers/notasEnCarpetaController.dart';
import 'package:firstapp/controllerFactory.dart';
import 'package:firstapp/infrastructure/views/folderWidgets/noteFolderPreview.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/textEditor.dart';

//import '../nota_nueva.dart';

// ignore: must_be_immutable

// Ventana para consultar las notas dentro de una carpeta

// ignore: must_be_immutable
class NotasEnCarpeta extends StatelessWidget {
  String nombreCarpeta;
  String idCarpeta;
  NotasEnCarpeta(
      {super.key, required this.nombreCarpeta, required this.idCarpeta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nombreCarpeta),
        backgroundColor: const Color.fromARGB(255, 30, 103, 240),
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 30, 103, 240),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditarCarpeta(
                            nombreCarpeta: nombreCarpeta,
                            idCarpeta: idCarpeta)));
              },
              child: const Text("Editar")),
        ],
      ),
// Boton pars crear una nueva nota
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 30, 103, 240),
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

      body: Center(child: NotasCarpeta(idCarpeta: idCarpeta)),
    );
  }
}

// ignore: must_be_immutable
class NotasCarpeta extends StatefulWidget {
  String idCarpeta;
  NotasCarpeta({super.key, required this.idCarpeta});

  @override
  State<NotasCarpeta> createState() => NotasCarpetaState(idCarpeta: idCarpeta);
}

class NotasCarpetaState extends State<NotasCarpeta> {
  String idCarpeta;
  List<Nota> notas = <Nota>[];
  bool loading = false;
  NotasCarpetaState({required this.idCarpeta});

  // Se asigna el controlador con la logica de la ventana notas en carpeta
  notasEnCarpetaController controller =
      controllerFactory.createnotasEnCarpetaController();

  @override
  void initState() {
    super.initState();
    showNotes(idCarpeta);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        child: loading == true
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
      ),
    );
  }

  void reset() {
    setState(() {
      loading = true;
    });
  }

  void showNotes(String idCarpeta) async {
    controller.getNotesByFolder(this, idCarpeta);
  }

  Widget notePreview(Nota note) {
    return (noteFolderPreviewWidget(nota: note, home: this));
  }

  void showSystemMessage(String? message) {
    setState(() {
      loading = false;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message!)));
  }
}
