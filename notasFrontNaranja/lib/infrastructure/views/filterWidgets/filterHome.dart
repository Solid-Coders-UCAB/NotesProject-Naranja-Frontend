import 'package:flutter/material.dart';
import 'package:firstapp/infrastructure/views/etiquetasWidgets/editarEtiqueta.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/infrastructure/controllers/notasPorEtiquetaController.dart';
import 'package:firstapp/controllerFactory.dart';
import 'package:firstapp/infrastructure/views/etiquetasWidgets/noteEtiquetaPreviewWidget.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/textEditor.dart';
import 'package:firstapp/infrastructure/views/filterWidgets/searchNotaDelegate.dart';
//import '../nota_nueva.dart';

// ignore: must_be_immutable

// Ventana para consultar las notas dentro de una carpeta

// ignore: must_be_immutable
class FilterHome extends StatelessWidget {

  FilterHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filtrar"),
        backgroundColor: const Color.fromARGB(255, 99, 91, 250),
        leading: 
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {Navigator.pop(context); }
            ),
        actions: <Widget>[
          IconButton(
                    onPressed: () {
                      showSearch(context: context, 
                      delegate: searchNotaDelegate());
                    },
                    icon: const Icon(Icons.search),    
                        ),
        ],
      ),

      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 99, 91, 250),
          onPressed: () async {
            Navigator.push(
              context, MaterialPageRoute(builder: (context) => HtmlEditorExampleApp()));
          },
          heroTag: 'addButton',
          child: const Icon(Icons.add),
        ),
      ),

      body: Center(
        child: HomeFilter()
      ),
    );
  }
}

// ignore: must_be_immutable
class HomeFilter extends StatefulWidget {
  HomeFilter({super.key});

  @override
  // ignore: no_logic_in_create_state
  State<HomeFilter> createState() => HomeFilterState();
}

class HomeFilterState extends State<HomeFilter> {

  List<Nota> notas = <Nota>[];
  bool loading = false;

  HomeFilterState();

  // Se asigna el controlador con la logica de la ventana 
  //notasPorEtiquetaController controller = controllerFactory.createnotasPorEtiquetaController();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(

      ),
    );
  }


}
