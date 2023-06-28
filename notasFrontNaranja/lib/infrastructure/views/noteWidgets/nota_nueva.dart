import 'package:firstapp/controllerFactory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../controllers/notaNuevaWidgetController.dart';
import '../systemWidgets/widgets.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/ver_imagen.dart';

import 'home.dart';

// ignore: must_be_immutable
class NotaNueva extends StatelessWidget {

  homeState? h;
  
  NotaNueva(this.h,{super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nueva nota"),
        backgroundColor: const Color.fromARGB(255, 99, 91, 250),
        leading: 
            IconButton(
              icon: new Icon(Icons.transit_enterexit_outlined),
              onPressed: () {h!.showNotes(); Navigator.pop(context); }
            ),
      ),
      body: Center(
        child: NuevaNota(h!)
      ),
    );
  }
}

// ignore: must_be_immutable
class NuevaNota extends StatefulWidget {

  homeState home;
  NuevaNota(this.home,{super.key});

  @override
  State<NuevaNota> createState() => NuevaNotaState(home);
}

class NuevaNotaState extends State<NuevaNota> {

  homeState home;

  NuevaNotaState(this.home);

  String noteContent = '';
  String noteTitle = '';
  bool loading = false;
  Uint8List? imagen;
  notaNuevaWidgetController controller =
      controllerFactory.notaNuevaWidController();
  Uint8List? selectedImage;
  List<Uint8List> imagenes = [];

//

  final TextEditingController _tituloC = TextEditingController(text: "");
  final TextEditingController _contenidoC = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      //height: 500.0,
      color: Colors.white,
      child: loading == true
          ? const Center(
              child: SizedBox(
                  width: 30, height: 30, child: CircularProgressIndicator()))
          : SingleChildScrollView(
              // Se agrega esta linea para que se pueda ver todo el texto que se escribe en la nota
              child: Form(
                  child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                genericTextFormField(_tituloC, "Título de la nota", false, 40),
                imagenes.isEmpty
                    ? const Row()
                    : SizedBox(
                        height: 250,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: imagenes.length,
                          separatorBuilder: (_, __) {
                            return const SizedBox(width: 8);
                          },
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                String indicador = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VerImagen(imagenes[index])));
                                setState(() {
                                  selectedImage = imagenes[index];

                                  if (indicador == "true") {
                                    imagenes.remove(selectedImage);
                                  }
                                });
                              },
                              child: SizedBox(
                                //width: 400,
                                //height: 200,
                                child: Image.memory(imagenes[index]),
                              ),
                            );
                          },
                        ),
                      ),
                maxLinesTextFormField(
                    _contenidoC, "Contenido de la nota", false, 2000),
                loading == true
                    ? const Row()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [opcionesNota(this)]),
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
                            saveNota();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "El título de la nota no debe estar vacía")));
                          }
                        },
                        child: const Text("Aceptar")),
                    const SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 99, 91, 250),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        onPressed: () {regresarHome();},
                        child: const Text("Cancelar")),
                  ],
                ),
              ],
            ))),
    );
  }

  showSystemMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void regresarHome(){
    home.showNotes();
    Navigator.pop(context);
  }

  saveNota() async {
    setState(() {
      loading = true;
    });
    var response = await controller.saveNota(
        titulo: _tituloC.text, contenido: _contenidoC.text,imagenes: imagenes);
    if (response.isLeft) {
      setState(() {
        loading = false;
      });
      String text = '';
      text = response.left.message!;
      showSystemMessage(text);
    }
    if (response.isRight) {

      showSystemMessage('nota agregada satisfactoriamente');
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                 builder: (context) => Home()),(Route<dynamic> route) => false); 


    }
  }

  Future getTextFromIa() async {
    setState(() {
      loading = true;
    });
    var response = await controller.showTextFromIA();
    if (response.isLeft) {
      setState(() {
        loading = false;
      });
      String text = '';
      text = response.left.message!;
      showSystemMessage(text);
    }
    if (response.isRight) {
      setState(() {
        _contenidoC.text = "${_contenidoC.text}\n${response.right}";
        loading = false;
      });
    }
  }

  void showAudioToText({required String contenido, required String titulo}) {
    setState(() {
      noteContent = '$contenido ';
      _contenidoC.text = contenido;
      _tituloC.text = titulo;
      loading = false;
    });
  }

  String getTitulo() {
    return _tituloC.text;
  }

  String getContenido() {
    return _contenidoC.text;
  }

  void getEsbozado(Uint8List? bytes) {
    if (bytes != null) {
      setState(() {
        imagen = bytes;
        // imagenVisible = true;
        imagenes.add(bytes); // nuevo
      });
    }
  }

  void getFromGallery() async {
    var response = await controller.getImageGallery();

    if (response.isLeft) {
      String text = '';
      text = response.left.message!;
      showSystemMessage(text);
    } else {
      Uint8List bytes = response.right;
      setState(() {
        imagen = bytes;
        imagenes.add(bytes);
      });
    }
  }
}

