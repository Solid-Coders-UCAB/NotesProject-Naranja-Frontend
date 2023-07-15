import 'package:flutter/material.dart';
import 'package:firstapp/infrastructure/views/etiquetasWidgets/editarEtiqueta.dart';
//import '../nota_nueva.dart';

// ignore: must_be_immutable

// Ventana para consultar las notas dentro de una carpeta

// ignore: must_be_immutable
class NotasPorEtiqueta extends StatelessWidget {
  String nombreEtiqueta;
  String idEtiqueta;
  NotasPorEtiqueta({super.key, required this.nombreEtiqueta, required this.idEtiqueta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nombreEtiqueta),
        backgroundColor: const Color.fromARGB(255, 99, 91, 250),
        leading: 
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {Navigator.pop(context); }
            ),
        actions: <Widget>[
          ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 99, 91, 250),
                        ),
                        onPressed: () {
                        //  Navigator.push(context,
                        //                        MaterialPageRoute(builder: (context) => EditarCarpeta(nombreCarpeta: nombreCarpeta, idCarpeta: idCarpeta)));
                        },
                        child: const Text("Editar")
                        ),
        ],
      ),

      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 99, 91, 250),
          onPressed: () async {
            //Navigator.push(context,
             //              MaterialPageRoute(builder: (context) => NuevaNota()));
          },
          heroTag: 'addButton',
          child: const Icon(Icons.add),
        ),
      ),

      body: Center(
        child: NotasEtiqueta()
      ),
    );
  }
}

// ignore: must_be_immutable
class NotasEtiqueta extends StatefulWidget {

  NotasEtiqueta({super.key});

  @override
  State<NotasEtiqueta> createState() => NotasEtiquetaState();
}

class NotasEtiquetaState extends State<NotasEtiqueta> {


  NotasEtiquetaState();

//

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(

      ),
    );
  }

}