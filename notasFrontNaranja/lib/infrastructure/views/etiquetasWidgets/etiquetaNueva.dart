import 'package:firstapp/infrastructure/views/etiquetasWidgets/etiquetasHome.dart';
import 'package:firstapp/controllerFactory.dart';
import 'package:flutter/material.dart';
import '../../controllers/etiquetaNuevaWidgetController.dart';
import '../systemWidgets/widgets.dart';

// Ventana para crear una etiqueta
class EtiquetaNueva extends StatelessWidget {
  const EtiquetaNueva({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nueva Etiqueta"),
        backgroundColor: const Color.fromARGB(255, 30, 103, 240),
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: const Center(child: NuevaEtiqueta()),
    );
  }
}

// ignore: must_be_immutable
class NuevaEtiqueta extends StatefulWidget {
  const NuevaEtiqueta({super.key});

  @override
  State<NuevaEtiqueta> createState() => NuevaEtiquetaState();
}

class NuevaEtiquetaState extends State<NuevaEtiqueta> {
  NuevaEtiquetaState();
  bool loading = false;

// Se crea el controlador con la logica de la ventana EtiquetaNueva
  etiquetaNuevaWidgetController controller =
      controllerFactory.createEtiquetaNuevaWidgetController();

//

  final TextEditingController _nombreEtiqueta = TextEditingController(text: "");

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
                      _nombreEtiqueta, "Nombre de la etiqueta", false, 40),
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
                            if (_nombreEtiqueta.text != '') {
                              crearCarpeta(_nombreEtiqueta.text);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "El nombre de la etiqueta no debe estar vacío")));
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
        MaterialPageRoute(builder: (context) => const etiquetasHome()),
        (Route<dynamic> route) => false);
  }

  showSystemMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

// Funcion para crear una etiqueta
  Future crearCarpeta(String nombreEtiqueta) async {
    setState(() {
      loading = true;
    });
    // Se llama a la funcion del controlador para crear una etiqueta
    var response =
        await controller.createEtiqueta(nombreEtiqueta: nombreEtiqueta);

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
