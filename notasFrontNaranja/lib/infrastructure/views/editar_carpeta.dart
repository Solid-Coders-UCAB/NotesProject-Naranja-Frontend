import 'package:firstapp/controllerFactory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../controllers/notaNuevaWidgetController.dart';
import './widgets.dart';

class EditarCarpeta extends StatelessWidget {
  
  EditarCarpeta({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Carpeta"),
        backgroundColor: const Color.fromARGB(255, 99, 91, 250),
        leading: 
            IconButton(
              icon: new Icon(Icons.close),
              onPressed: () {Navigator.pop(context); }
            ),
        actions: <Widget>[
          ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 99, 91, 250),
                        ),
                        onPressed: () {

                        },
                        child: const Text("Cambiar nombre")
                        ),
        ],
      ),
      body: Center(
        child: CarpetaEditar()
      ),
    );
  }
}

// ignore: must_be_immutable
class CarpetaEditar extends StatefulWidget {

  CarpetaEditar({super.key});

  @override
  State<CarpetaEditar> createState() => CarpetaEditarState();
}

class CarpetaEditarState extends State<CarpetaEditar> {


  CarpetaEditarState();

  String carpetaTitle = '';
  bool loading = false;
  Uint8List? imagen;
  notaNuevaWidgetController controller =
      controllerFactory.notaNuevaWidController();
  Uint8List? selectedImage;
  List<Uint8List> imagenes = [];

//

  final TextEditingController _tituloC = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        //height: 500.0,
        color: Colors.white,
        child: loading == true
            ? const Center(
                child: SizedBox(
                    width: 30, height: 30, child: CircularProgressIndicator()))
            : SingleChildScrollView(
                // Se agrega esta linea para que se pueda ver todo el texto que se escribe en la nota
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  genericTextFormField(_tituloC, "Nombre de la carpeta", false, 40),
    
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            backgroundColor:
                                const Color.fromARGB(255, 99, 91, 250),
                          ),
                          onPressed: () {
                            if (_tituloC.text != '') {
                           // Aqui se crea la carpeta
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "El título de la nota no debe estar vacía")));
                            }
                          },
                          child: const Text("Cambiar nombre")),
                      const SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                ],
              )
              ),
      ),
    );
  }

}