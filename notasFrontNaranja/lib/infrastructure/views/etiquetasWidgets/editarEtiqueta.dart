import 'package:firstapp/controllerFactory.dart';
import 'package:firstapp/infrastructure/controllers/editarEtiquetaWidgetController.dart';
import 'package:flutter/material.dart';
import '../systemWidgets/widgets.dart';
import 'package:firstapp/infrastructure/views/etiquetasWidgets/etiquetasHome.dart';

// Ventana para editar el nombre de una etiqueta

// ignore: must_be_immutable
class EditarEtiqueta extends StatelessWidget {
  String nombreEtiqueta;
  String idEtiqueta;
  EditarEtiqueta({super.key, required this.nombreEtiqueta, required this.idEtiqueta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Etiqueta"),
        backgroundColor: const Color.fromARGB(255, 99, 91, 250),
        leading: 
            IconButton(
              icon: new Icon(Icons.close),
              onPressed: () {Navigator.pop(context); }
            ),
      ),
      body: Center(
        child: EtiquetaEditar(nombreEtiqueta: nombreEtiqueta, idEtiqueta: idEtiqueta,)
      ),
    );
  }
}

// ignore: must_be_immutable
class EtiquetaEditar extends StatefulWidget {
  String nombreEtiqueta;
  String idEtiqueta;
  EtiquetaEditar({super.key, required this.nombreEtiqueta, required this.idEtiqueta});

  @override
  // ignore: no_logic_in_create_state
  State<EtiquetaEditar> createState() => EtiquetaEditarState(nombreEtiqueta: nombreEtiqueta, idEtiqueta: idEtiqueta);
}

class EtiquetaEditarState extends State<EtiquetaEditar> {
  String nombreEtiqueta;
  String idEtiqueta;
  EtiquetaEditarState({required this.nombreEtiqueta, required this.idEtiqueta});
  String carpetaTitle = '';
  bool loading = false;

  // Se crea un controlador con la logica para Editar Etiqueta
  editarEtiquetaWidgetController controller =
      controllerFactory.createEditarEtiquetaWidgetController();


  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers

    final TextEditingController _nombreEtiqueta = TextEditingController(text: nombreEtiqueta);
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  genericTextFormField(_nombreEtiqueta, "Nombre de la etiqueta", false, 40),
    
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    // Boton para cambiar el nombre de la etiqueta
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            backgroundColor:
                                const Color.fromARGB(255, 99, 91, 250),
                          ),
                          onPressed: () {
                            if (_nombreEtiqueta.text != '') {
                              updateEtiqueta(_nombreEtiqueta.text, idEtiqueta);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "El título de la etiqueta no debe estar vacío")));
                            }
                          },
                          child: const Text("Cambiar nombre")),
                      // Boton para eliminar la etiqueta
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            backgroundColor:
                                const Color.fromARGB(255, 99, 91, 250),
                          ),
                          onPressed: () {
                            deleteEtiqueta(idEtiqueta);
                            ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Etiqueta eliminada")));
                          },
                          child: const Text("Eliminar")),
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

// Funcion para editar una carpeta
  updateEtiqueta(String nombreEtiqueta, String idEtiqueta) async {
    setState(() {
      loading = true;
    });
    
    // Se llama a la funcion del controlador para editar la etiqueta
    var response = await controller.updateEtiqueta(
      nombreEtiqueta: nombreEtiqueta,
      idEtiqueta: idEtiqueta
      );

    if (response.isLeft) {
      String text = '';
      text = response.left.message!;
      loading = false;
      showSystemMessage(text);   
    }
    if (response.isRight) {
      showSystemMessage('Etiqueta actualizada correctamente');

      // Se regresa a la ventana de HomeEtiqueta
       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
       builder: (context) => etiquetasHome()),(Route<dynamic> route) => false);
    }
  }

  deleteEtiqueta(String idEtiqueta) async {
    setState(() {
      loading = true;
    });
    
    // Se llama a la funcion del controlador para eliminar la etiqueta
    var response = await controller.deleteEtiqueta(
      idEtiqueta: idEtiqueta
      );

    if (response.isLeft) {
      String text = '';
      text = response.left.message!;
      loading = false;
      showSystemMessage(text);   
    }
    if (response.isRight) {
      showSystemMessage('Etiqueta eliminada correctamente');

      // Se regresa a la ventana de HomeEtiqueta
       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
       builder: (context) => etiquetasHome()),(Route<dynamic> route) => false);
    }
  }

}