import 'package:firstapp/infrastructure/views/folderWidgets/folderHome.dart';
import 'package:firstapp/controllerFactory.dart';
import 'package:flutter/material.dart';
import '../../controllers/carpetaNuevaWidgetController.dart';
import '../systemWidgets/widgets.dart';

// Ventana para crear una carpeta
class CarpetaNueva extends StatelessWidget {
  const CarpetaNueva({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nueva Carpeta"),
        backgroundColor: const Color.fromARGB(255, 30, 103, 240),
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: const Center(child: NuevaCarpeta()),
    );
  }
}

// ignore: must_be_immutable
class NuevaCarpeta extends StatefulWidget {
  const NuevaCarpeta({super.key});

  @override
  State<NuevaCarpeta> createState() => NuevaCarpetaState();
}

class NuevaCarpetaState extends State<NuevaCarpeta> {
  NuevaCarpetaState();
  bool loading = false;

// Se crea el controlador con la logica de la ventana CarpetaNueva
  carpetaNuevaWidgetController controller =
      controllerFactory.createCarpetaNuevaWidgetController();

//

  final TextEditingController _nombreCarpeta = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        color: Colors.white,
        child: loading == true
            ? const Center(
                child: SizedBox(
                    width: 30, height: 30, child: CircularProgressIndicator()))
            : SingleChildScrollView(
                // Se agrega esta linea para que se pueda ver todo el texto que se escribe en la nota
                child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  genericTextFormField(
                      _nombreCarpeta, "Nombre de la carpeta", false, 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Boton para crear una nueva carpeta
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            backgroundColor:
                                const Color.fromARGB(255, 30, 103, 240),
                          ),
                          onPressed: () {
                            if (_nombreCarpeta.text != '') {
                              crearCarpeta(_nombreCarpeta.text);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "El nombre de la carpeta no debe estar vacío")));
                            }
                          },
                          child: const Text("Crear")),
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

  void regresarHome() {
    //home.showNotes();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => folderHome()),
        (Route<dynamic> route) => false);
  }

  showSystemMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

// Funcion para crear una carpeta
  Future crearCarpeta(String nombreCarpeta) async {
    setState(() {
      loading = true;
    });
    // Se llama a la funcion del controlador para crear una carpeta
    var response = await controller.createCarpeta(nombreCarpeta: nombreCarpeta);

    if (response.isLeft) {
      setState(() {
        loading = false;
      });
      String text = '';
      text = response.left.message!;
      showSystemMessage(text);
    }

    if (response.isRight) {
      loading = false;
      // Regresa a la ventana principal
      regresarHome();
    }
  }
}
