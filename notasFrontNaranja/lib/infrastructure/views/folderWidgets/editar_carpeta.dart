import 'package:firstapp/controllerFactory.dart';
import 'package:firstapp/infrastructure/controllers/editarCarpetaWidgetController.dart';
import 'package:flutter/material.dart';
import '../systemWidgets/widgets.dart';
import 'package:firstapp/infrastructure/views/folderWidgets/folderHome.dart';

// Ventana para editar el nombre de una carpeta

// ignore: must_be_immutable
class EditarCarpeta extends StatelessWidget {
  String nombreCarpeta;
  String idCarpeta;
  List<String> foldersNombre;
  EditarCarpeta(
      {super.key, required this.nombreCarpeta, required this.idCarpeta, required this.foldersNombre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Carpeta"),
        backgroundColor: const Color.fromARGB(255, 30, 103, 240),
        leading: IconButton(
            icon: new Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Center(
          child: CarpetaEditar(
        nombreCarpeta: nombreCarpeta,
        idCarpeta: idCarpeta, foldersNombre: foldersNombre,
      )),
    );
  }
}

// ignore: must_be_immutable
class CarpetaEditar extends StatefulWidget {
  String nombreCarpeta;
  String idCarpeta;
  List<String> foldersNombre;
  CarpetaEditar(
      {super.key, required this.nombreCarpeta, required this.idCarpeta, required this.foldersNombre});

  @override
  // ignore: no_logic_in_create_state
  State<CarpetaEditar> createState() =>
      // ignore: no_logic_in_create_state
      CarpetaEditarState(nombreCarpeta: nombreCarpeta, idCarpeta: idCarpeta, foldersNombre: foldersNombre);
}

class CarpetaEditarState extends State<CarpetaEditar> {
  String nombreCarpeta;
  String idCarpeta;
  List<String> foldersNombre;
  CarpetaEditarState({required this.nombreCarpeta, required this.idCarpeta, required this.foldersNombre});
  String carpetaTitle = '';
  bool loading = false;

  // Se crea un controlador con la logica para Editar Carpeta
  editarCarpetaWidgetController controller =
      controllerFactory.createEditarCarpetaWidgetController();

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers

    final TextEditingController _nombreCarpeta =
        TextEditingController(text: nombreCarpeta);
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
                  genericTextFormField(
                      _nombreCarpeta, "Nombre de la carpeta", false, 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Cambiar el nombre de la carpeta
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            backgroundColor:
                                const Color.fromARGB(255, 30, 103, 240),
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
                      // Boton para eliminar la carpeta
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            backgroundColor:
                                const Color.fromARGB(255, 30, 103, 240),
                          ),
                          onPressed: () {
                            deleteCarpeta(idCarpeta);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Carpeta eliminada")));
                          },
                          child: const Text("Eliminar")),
                      const SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                ],
              )),
      ),
    );
  }

  showSystemMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

// Funcion para editar una carpeta
  updateCarpeta(String nombreCarpeta, String idCarpeta) async {
    bool esRepetido = false;
    for (var element in foldersNombre) {
      if (element == nombreCarpeta) {
        esRepetido = true;
        print(element);
      }
    }


    if (!esRepetido) {
  setState(() {
    loading = true;
  });
  
  // Se llama a la funcion del controlador para evitar la carpeta
  var response = await controller.updateCarpeta(
      nombreCarpeta: nombreCarpeta, idCarpeta: idCarpeta);
  
  if (response.isLeft) {
    String text = '';
    text = response.left.message!;
    loading = false;
    showSystemMessage(text);
  }
  if (response.isRight) {
    showSystemMessage('carpeta actualizada correctamente');
  
    // Se regresa a la ventana de HomeCarpeta
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => folderHome()),
        (Route<dynamic> route) => false);
  }
}else{
  showSystemMessage("El nombre de la carpeta ya existe");
}
  }

  deleteCarpeta(String idCarpeta) async {
    setState(() {
      loading = true;
    });

    // Se llama a la funcion del controlador para eliminar la etiqueta
    var response = await controller.deleteCarpeta(idCarpeta: idCarpeta);

    if (response.isLeft) {
      String text = '';
      text = response.left.message!;
      loading = false;
      showSystemMessage(text);
    }
    if (response.isRight) {
      showSystemMessage('Carpeta eliminada correctamente');

      // Se regresa a la ventana de HomeEtiqueta
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => folderHome()),
          (Route<dynamic> route) => false);
    }
  }
}
