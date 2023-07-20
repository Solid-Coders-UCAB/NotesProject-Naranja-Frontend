import 'package:firstapp/infrastructure/views/etiquetasWidgets/etiquetasHome.dart';
import 'package:firstapp/controllerFactory.dart';
import 'package:flutter/material.dart';
import '../../controllers/etiquetaNuevaWidgetController.dart';
import '../systemWidgets/widgets.dart';

// Ventana para crear una etiqueta
// ignore: must_be_immutable
class EtiquetaNueva extends StatelessWidget {
  List<String> etiquetasNombre;
  EtiquetaNueva({super.key, required this.etiquetasNombre});

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
      body: Center(child: NuevaEtiqueta(etiquetasNombre: etiquetasNombre)),
    );
  }
}

// ignore: must_be_immutable
class NuevaEtiqueta extends StatefulWidget {
  List<String> etiquetasNombre;
  NuevaEtiqueta({super.key, required this.etiquetasNombre});

  @override
  // ignore: no_logic_in_create_state
  State<NuevaEtiqueta> createState() => NuevaEtiquetaState(etiquetasNombre: etiquetasNombre);
}

class NuevaEtiquetaState extends State<NuevaEtiqueta> {
  List<String> etiquetasNombre;
  NuevaEtiquetaState({required this.etiquetasNombre});
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
                              crearEtiqueta(_nombreEtiqueta.text);
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
  Future crearEtiqueta(String nombreEtiqueta) async {
    bool esRepetido = false;
    for (var element in etiquetasNombre) {
      if (element == nombreEtiqueta) {
        esRepetido = true;
        
      }
    }

    // Se llama a la funcion del controlador para crear una etiqueta
    if (!esRepetido) {
          setState(() {
      loading = true;
    });
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
}else{
  showSystemMessage("El nombre de la etiqueta ya existe");
}

  }
}
