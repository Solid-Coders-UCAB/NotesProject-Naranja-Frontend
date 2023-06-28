import 'package:firstapp/controllerFactory.dart';
import 'package:firstapp/infrastructure/controllers/editarCarpetaWidgetController.dart';
import 'package:flutter/material.dart';
import '../widgets.dart';
import 'package:firstapp/infrastructure/views/folderWidgets/folderHome.dart';

// ignore: must_be_immutable
class EditarCarpeta extends StatelessWidget {
  String nombreCarpeta;
  String idCarpeta;
  EditarCarpeta({super.key, required this.nombreCarpeta, required this.idCarpeta});

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
      ),
      body: Center(
        child: CarpetaEditar(nombreCarpeta: nombreCarpeta, idCarpeta: idCarpeta,)
      ),
    );
  }
}

// ignore: must_be_immutable
class CarpetaEditar extends StatefulWidget {
  String nombreCarpeta;
  String idCarpeta;
  CarpetaEditar({super.key, required this.nombreCarpeta, required this.idCarpeta});

  @override
  // ignore: no_logic_in_create_state
  State<CarpetaEditar> createState() => CarpetaEditarState(nombreCarpeta: nombreCarpeta, idCarpeta: idCarpeta);
}

class CarpetaEditarState extends State<CarpetaEditar> {
  String nombreCarpeta;
  String idCarpeta;
  CarpetaEditarState({required this.nombreCarpeta, required this.idCarpeta});

  String carpetaTitle = '';
  bool loading = false;
  editarCarpetaWidgetController controller =
      controllerFactory.createEditarCarpetaWidgetController();


  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final TextEditingController _nombreCarpeta = TextEditingController(text: nombreCarpeta);
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
                  genericTextFormField(_nombreCarpeta, "Nombre de la carpeta", false, 40),
    
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
                            if (_nombreCarpeta.text != '') {
                              updateCarpeta(_nombreCarpeta.text, idCarpeta);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "El título de la carpeta no debe estar vacío")));
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

  showSystemMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  updateCarpeta(String nombreCarpeta, String idCarpeta) async {
    setState(() {
      loading = true;
    });
    
    var response = await controller.updateCarpeta(
      nombreCarpeta: nombreCarpeta,
      idCarpeta: idCarpeta
      );

    if (response.isLeft) {
      String text = '';
      text = response.left.message!;
      loading = false;
      showSystemMessage(text);   
    }
    if (response.isRight) {
      showSystemMessage('carpeta actualizada correctamente');
       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
       builder: (context) => folderHome()),(Route<dynamic> route) => false);
    }
  }

}