import 'package:flutter/material.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/infrastructure/controllers/notasPorPalabraClaveController.dart';
import 'package:firstapp/controllerFactory.dart';
import 'package:firstapp/infrastructure/views/filterWidgets/noteKeywordPreviewWidget.dart';

class searchNotaDelegate extends SearchDelegate{

  notasPorPalabraClaveController controller = controllerFactory.createnotasPorPalabraClaveController();
  @override
  String get query;
  List<Nota> notas = <Nota>[];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return const Text('');
  }

  @override
  Widget buildResults(BuildContext context) {
    print("Buscando las notas");
    print(query);
    print(notas.length);
    return NotasCarpeta(idCarpeta: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Text('');
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
   notasPorPalabraClaveController controller = controllerFactory.createnotasPorPalabraClaveController();

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
        child : 
        ListView.builder(
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

  void showNotes(String palabraClave) async { 
    controller.getNotesByKeyword(this, palabraClave);
  }

  Widget notePreview(Nota note) {
    return (noteKeywordPreviewWidget(
        nota: note));
  }

  void showSystemMessage(String? message){
    setState(() {
      loading = false;
    });
     ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message!)));
  }

}