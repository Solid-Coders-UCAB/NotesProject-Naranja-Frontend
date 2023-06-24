
import 'package:firstapp/domain/nota.dart';
import 'package:flutter/material.dart';
import '../nota_nueva.dart';
import 'notePreview.dart';


// En este código está toda la interfaz de la app de notas
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

  @override
  Widget build(BuildContext context) {
    // Future<List<Nota>> listOfNotes = notesRequest(id_client);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 99, 91, 250),
        title: const Text("Notas"),
      ),
     
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return notePreview();
        },
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
      ),
      
    );
  }


void createNote() async {
            //Abrir pagina de agregar nota
    String? refresh01 = await Navigator.push(context,MaterialPageRoute(builder: (context) => const NotaNueva()));
    if (refresh01 == 'refresh') {
              //refresh(id_client);
    }
}

Widget notePreview(){
  return(notePreviewWidget(nota: Nota(contenido: 'hola',titulo: 'titulo nota')));
}

}

class MyListWidget extends StatelessWidget {
  final List<String> cosas = ['Cosas 1', 'Cosas 2', 'Cosas 3'];

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

  void reset(){
    
  }

}
