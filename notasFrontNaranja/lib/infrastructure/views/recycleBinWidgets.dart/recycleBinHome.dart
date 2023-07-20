import 'dart:typed_data';

import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/infrastructure/controllers/recycleBinHomeController.dart';
import 'package:flutter/material.dart';
import '../systemWidgets/navigationBar.dart';
import 'package:firstapp/controllerFactory.dart';

class recycleBinHome extends StatefulWidget {
  const recycleBinHome({super.key});

  @override
  recycleBinHomeState createState() => recycleBinHomeState();
}

class recycleBinHomeState extends State<recycleBinHome> {
  recycleBinHomeState();

  bool loading = false;
  List<Nota> notas = <Nota>[];
  final TextEditingController buscarNota = TextEditingController(text: '');
  recycleBinHomeController controller =
      controllerFactory.recycleBinhomeController();
  bool showNBottons = false;

  void changeState({required List<Nota> notas, required bool loading}) {
    setState(() {
      this.loading = loading;
      this.notas = notas;
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
    controller.getAllNotesFromServer(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 30, 103, 240),
          title: const Text("Papelera"),
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
        body: loading == true
            ? const Center(
                child: SizedBox(
                    width: 30, height: 30, child: CircularProgressIndicator()))
            : listaCarpetas());
  }

  Widget listaCarpetas() {
    return ListView.builder(
      itemCount: notas.length,
      itemBuilder: (context, index) {
        return notePreview(index);
      },
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
    );
  }

  void refresh(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const recycleBinHome()));
  }

  Widget notePreview(int index) {
    return Card(
        child: Material(
            child: ListTile(
      title: Text(notas[index].getTitulo),
      leading: iconNotePreview(index),
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ListTile(
                    title: Text('Opciones'),
                  ),
                  ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Eliminar permanentemente'),
                    onTap: () {
                      Navigator.pop(context);
                      eliminarPermanentementeOnPressed(notas[index]);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.check),
                    title: Text('Restaurar'),
                    onTap: () {
                      Navigator.pop(context);
                      restaurarOnPressed(notas[index]);
                    },
                  ),
                ],
              );
            });
      },
    )));
  }

  void eliminarPermanentementeOnPressed(Nota note) {
    controller.deleteNote(this, note);
  }

  void restaurarOnPressed(Nota note) {
    controller.restaurarNote(this, note);
  }

  Widget botonesNotePreview() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {},
            child: Text('Botón 1'),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
          ),
          ElevatedButton(onPressed: () {}, child: Text('Botón 2')),
        ]);
  }

  Widget iconNotePreview(int index) {
    Uint8List? image = notas[index].getFirstImage();
    if (image == null) {
      return const CircleAvatar(
          radius: 35,
          backgroundColor: Colors.white38,
          child: Icon(Icons.note_rounded));
    }
    return CircleAvatar(radius: 35, backgroundImage: Image.memory(image).image);
  }

  void reset() {
    setState(() {
      loading = false;
    });
  }

  void setLoadingState({required bool l}) {
    setState(() {
      loading = l;
    });
  }
}
