import 'package:firstapp/domain/nota.dart';
import 'package:flutter/material.dart';
import '../../../domain/folder.dart';
import '../../controllers/homeFolderController.dart';
import '../systemWidgets/navigationBar.dart';
import 'package:firstapp/controllerFactory.dart';
import 'package:firstapp/infrastructure/views/folderWidgets/carpeta_nueva.dart';

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
  homeFolderController controller = controllerFactory.homefolderController();

  void changeState({required List<Nota> notas,required bool loading}){
    setState(() {
      this.loading = loading ;
      this.notas = notas;
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
      drawer: const NavBar(),

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
                                return
                                   Card(
                                        child: 
                                         Material(
                                            child: ListTile(
                                            title: Text(folders[index].name),
                                            leading: const Icon(Icons.folder),
                                        ),      
                                      )
                                    );  
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
