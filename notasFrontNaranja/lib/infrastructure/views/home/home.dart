import 'package:firstapp/controllerFactory.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/infrastructure/controllers/homeController.dart';
import 'package:flutter/material.dart';
import '../nota_nueva.dart';
import 'notePreview.dart';
import 'package:firstapp/infrastructure/views/home/navigationBar.dart';

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
  
  bool loading = false;
  List<Nota> notas = <Nota>[];
  homeController controller = controllerFactory.createHomeController();

  @override
  void initState() {
    super.initState();
    showNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 99, 91, 250),
        title: const Text("Notas"),
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
      drawer: const NavBar(),

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

      body: loading == true
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
    );
  }

  void reset() {
    setState(() {
      loading = true;
    });
  }

  void setLoadingState() {
    setState(() {
      loading = true;
    });
  }

  void showNotes() async {
    loading = true;
    var response = await controller.getAllNotesFromServer(this);
    if (response.isRight) {
      setState(() {
        notas = response.right;
        loading = false;
      });
    }
  }

  void createNote() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NotaNueva(this)));
  }

  Widget notePreview(Nota note) {
    return (notePreviewWidget(
        nota: note, home: this));
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
}
