// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';

import '../../../domain/folder.dart';
import '../../controllers/homeFolderController.dart';
import '../home/navigationBar.dart';
import 'package:firstapp/controllerFactory.dart';

class folderHome extends StatefulWidget {
  
  const folderHome({super.key});

  @override
  folderHomeState createState() => folderHomeState();
}

class folderHomeState extends State<folderHome> {
  
  folderHomeState();
  
  bool loading = false;
  List<folder> folders = <folder>[];
  final TextEditingController buscarNota = TextEditingController(text: '');
  homeFolderController controller = controllerFactory.homefolderController();

  void changeState(List<folder> f){
    setState(() {
      loading = false;
      folders = f;
    });
  }

  void showSystemMessage(String? message){
    setState(() {
      loading = false;
    });
     ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message!)));
  }

  @override
  void initState() {
    super.initState();
    controller.getAllFolders(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 99, 91, 250),
        title: const Text("Carpetas"),
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
          : 
          listaCarpetas()
        );
        
  }

  Widget listaCarpetas(){

     return 
                 ListView.builder(
                          itemCount: folders.length + 1 ,
                          itemBuilder: (context, index) {
                            if (index == folders.length){
                              return const Card(
                                      child: 
                                       Material(
                                          child: ListTile(
                                          title: Text("agregar nueva carpeta"),
                                          leading: Icon(Icons.plus_one),
                                          )
                                        )
                                      );
                            }
                                return(Card(
                                      child: 
                                       Material(
                                          child: ListTile(
                                          title: Text(folders[index].name),
                                          leading: const Icon(Icons.folder),
        ),      
      )
    )); 
                          },
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
     );
                
  }




  void reset() {
    setState(() {
      loading = false;
    });
  }

  void setLoadingState(bool l) {
    setState(() {
      loading = l;
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