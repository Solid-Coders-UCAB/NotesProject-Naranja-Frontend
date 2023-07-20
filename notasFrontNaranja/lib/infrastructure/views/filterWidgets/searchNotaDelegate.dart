import 'package:flutter/material.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/infrastructure/controllers/notasPorPalabraClaveController.dart';
import 'package:firstapp/controllerFactory.dart';
import 'package:firstapp/infrastructure/views/filterWidgets/noteKeywordPreviewWidget.dart';

class searchNotaDelegate extends SearchDelegate{

  @override
  String get searchFieldLabel => 'Buscar';

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
    return  NotasFiltradas(palabraClave: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Text('');
  }


}
// ignore: must_be_immutable
class NotasFiltradas extends StatefulWidget {
  String palabraClave;
  NotasFiltradas({super.key, required this.palabraClave});

  @override
  State<NotasFiltradas> createState() => NotasFiltradasState(palabraClave: palabraClave);
}

class NotasFiltradasState extends State<NotasFiltradas> {
  String palabraClave;
  List<Nota> notas = <Nota>[];
  bool loading = false;
  NotasFiltradasState({required this.palabraClave});

  // Se asigna el controlador con la logica de la ventana notas en carpeta
   notasPorPalabraClaveController controller = controllerFactory.createnotasPorPalabraClaveController();

  @override
  void initState() {
    super.initState();
    showNotes(palabraClave);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        child : loading == true
            ? const Center(
                child: SizedBox(
                    width: 30, height: 30, child: CircularProgressIndicator()))
            :
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