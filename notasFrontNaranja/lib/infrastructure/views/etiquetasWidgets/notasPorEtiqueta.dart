import 'package:flutter/material.dart';
import 'package:firstapp/infrastructure/views/etiquetasWidgets/editarEtiqueta.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/infrastructure/controllers/notasPorEtiquetaController.dart';
import 'package:firstapp/controllerFactory.dart';
import 'package:firstapp/infrastructure/views/etiquetasWidgets/noteEtiquetaPreviewWidget.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/textEditor.dart';
//import '../nota_nueva.dart';

// ignore: must_be_immutable

// Ventana para consultar las notas dentro de una carpeta

// ignore: must_be_immutable
class NotasPorEtiqueta extends StatelessWidget {
  String nombreEtiqueta;
  String idEtiqueta;
  List<String> etiquetasNombre = [];

  NotasPorEtiqueta(
      {super.key, required this.nombreEtiqueta, required this.idEtiqueta, required this.etiquetasNombre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nombreEtiqueta),
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
                        builder: (context) => EditarEtiqueta(
                            nombreEtiqueta: nombreEtiqueta,
                            idEtiqueta: idEtiqueta,
                            etiquetasNombre: etiquetasNombre,)));
              },
              child: const Text("Editar")),
        ],
      ),
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
      body: Center(
          child: NotasEtiqueta(
        idEtiqueta: idEtiqueta,
      )),
    );
  }
}

// ignore: must_be_immutable
class NotasEtiqueta extends StatefulWidget {
  String idEtiqueta;
  NotasEtiqueta({super.key, required this.idEtiqueta});

  @override
  // ignore: no_logic_in_create_state
  State<NotasEtiqueta> createState() =>
      NotasEtiquetaState(idEtiqueta: idEtiqueta);
}

class NotasEtiquetaState extends State<NotasEtiqueta> {
  String idEtiqueta;
  List<Nota> notas = <Nota>[];
  bool loading = false;

  NotasEtiquetaState({required this.idEtiqueta});

  // Se asigna el controlador con la logica de la ventana notas con etiqueta
  notasPorEtiquetaController controller =
      controllerFactory.createnotasPorEtiquetaController();

  @override
  void initState() {
    super.initState();
    showNotes(idEtiqueta);
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

  void showNotes(String idEtiqueta) async {
    controller.getNotesByEtiqueta(
      this,
      idEtiqueta,
    );
  }

  Widget notePreview(Nota note) {
    return (noteEtiquetaPreviewWidget(nota: note, home: this));
  }

  void showSystemMessage(String? message) {
    setState(() {
      loading = false;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message!)));
  }
}
