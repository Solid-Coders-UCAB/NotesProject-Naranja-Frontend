import 'package:flutter/material.dart';
import '../../../domain/etiqueta.dart';
import '../../controllers/homeEtiquetasController.dart';
import '../systemWidgets/navigationBar.dart';
import 'package:firstapp/controllerFactory.dart';
import 'package:firstapp/infrastructure/views/etiquetasWidgets/etiquetaNueva.dart';
// Ventana que muestra todas las etiquetas que ha creado el usuario
class etiquetasHome extends StatefulWidget {
  
  const etiquetasHome({super.key});

  @override
  etiquetasHomeState createState() => etiquetasHomeState();
}

class etiquetasHomeState extends State<etiquetasHome> {
  
  etiquetasHomeState();
  
  bool loading = false;
  List<etiqueta> etiquetas = <etiqueta>[];
  final TextEditingController buscarNota = TextEditingController(text: '');

  // Se crea un controlador con la logica de la ventana HomeEtiquetasController
  homeEtiquetasController controller = controllerFactory.createHomeEtiquetasController();

  void changeState(List<etiqueta> f){
    setState(() {
      loading = false;
      etiquetas = f;
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
    controller.getAllLabels(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 99, 91, 250),
        title: const Text("Etiquetas"),
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
      // Boton para crear una nota
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 99, 91, 250),
          // Al tocar este boton se abre la ventana para crear una nota en la carpeta por defecto
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
          listaEtiquetas()
        );
        
  }

// Lista con los nombres de las etiquetas del usuario
  Widget listaEtiquetas(){
     return 
      ListView.builder(
        itemCount: etiquetas.length + 1 ,
        itemBuilder: (context, index) {
        if (index == etiquetas.length){
          return GestureDetector(
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => const EtiquetaNueva())
              );
            },
            child: const Card(
              child: 
                Material(
                  child: ListTile(
                    title: Text("Etiqueta nueva"),
                    leading: Icon(Icons.new_label),
                  )
              )
            ),
          );
        }
        return GestureDetector(
          onTap: () {
           // Navigator.push(context,
           //   MaterialPageRoute(builder: (context) => NotasEnCarpeta(nombreCarpeta: folders[index].name, idCarpeta: folders[index].id.toString(),))
           //   );
          },
          child: ( Card(
                  child: 
                    Material(
                      child: ListTile(
                      title: Text(etiquetas[index].nombre),
                      leading: const Icon(Icons.label),
                      ),      
                     )
                  )),
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


