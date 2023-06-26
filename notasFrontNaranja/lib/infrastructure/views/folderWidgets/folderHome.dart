import 'package:flutter/material.dart';

import '../../../domain/folder.dart';
import '../home/navigationBar.dart';

class folderHome extends StatefulWidget {
  
  folderHome({super.key});

  @override
  folderHomeState createState() => folderHomeState();
}

class folderHomeState extends State<folderHome> {
  
  folderHomeState();
  
  bool loading = false;
  List<folder> folders = <folder>[];
  //homeFolderController controller = controllerFactory.createHomeFolderController();

  @override
  void initState() {
    super.initState();
    //showAllFolders();
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
           // createNote();
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
              itemCount: folders.length,
              itemBuilder: (context, index) {
                return Text('por hacer');
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