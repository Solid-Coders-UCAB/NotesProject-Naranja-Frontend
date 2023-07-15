import 'package:flutter/material.dart';
import 'package:firstapp/infrastructure/views/folderWidgets/editar_carpeta.dart';
//import '../nota_nueva.dart';

// ignore: must_be_immutable

// Ventana para consultar las notas dentro de una carpeta

// ignore: must_be_immutable
class NotasEnCarpeta extends StatelessWidget {
  String nombreCarpeta;
  String idCarpeta;
  NotasEnCarpeta({super.key, required this.nombreCarpeta, required this.idCarpeta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nombreCarpeta),
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
                          Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => EditarCarpeta(nombreCarpeta: nombreCarpeta, idCarpeta: idCarpeta)));
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
        child: NotasCarpeta()
      ),
    );
  }
}

// ignore: must_be_immutable
class NotasCarpeta extends StatefulWidget {

  NotasCarpeta({super.key});

  @override
  State<NotasCarpeta> createState() => NotasCarpetaState();
}

class NotasCarpetaState extends State<NotasCarpeta> {


  NotasCarpetaState();

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