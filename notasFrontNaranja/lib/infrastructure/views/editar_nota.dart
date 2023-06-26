import 'dart:typed_data';
import 'package:flutter/material.dart';
import './widgets.dart';
import 'package:firstapp/infrastructure/views/ver_imagen.dart';
import 'package:firstapp/controllerFactory.dart';
import '../controllers/editarNotaWidgetController.dart';
import 'package:firstapp/infrastructure/views/drawing_room_screen.dart';
import 'package:firstapp/infrastructure/views/speech_to_text_prueba.dart';
import 'package:firstapp/domain/nota.dart';
import 'home/home.dart';
/// Esta ventana se abre al seleccionar una nota para editarla o eliminarla
///
// ignore: must_be_immutable
class EditarNota extends StatelessWidget {
  String tituloNota;
  String contenidoNota;
  List<Uint8List>? imagenes = [];
  Nota note;
  homeState h;

  EditarNota({super.key, required this.tituloNota, required this.contenidoNota, required this.imagenes, required this.note, required this.h});

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
        child: NotaEditar(tituloNota: tituloNota, contenidoNota: contenidoNota, imagenes: imagenes, note: note, home: h),
      ),
    );
  }
}

// ignore: must_be_immutable
class NotaEditar extends StatefulWidget {
  String tituloNota;
  String contenidoNota;
  Nota note;
  homeState home;
  List<Uint8List>? imagenes = [];

  NotaEditar({super.key, required this.tituloNota, required this.contenidoNota, required this.imagenes, required this.note, required this.home});

  @override
  // ignore: no_logic_in_create_state
  State<NotaEditar> createState() => EditarNotaState(tituloNota: tituloNota, contenidoNota: contenidoNota, imagenes: imagenes, note: note, home: home);
}

class EditarNotaState extends State<NotaEditar> {
  String tituloNota;
  String contenidoNota;
  List<Uint8List>? imagenes = [];
  Nota note;
  homeState home;
  EditarNotaState({required this.tituloNota, required this.contenidoNota, required this.imagenes, required this.note, required this.home});

  Uint8List? selectedImage;
  
  editarNotaWidgetController controller =
      controllerFactory.editarNotaWidController();

  bool loading = false;
  
  @override
  Widget build(BuildContext context) {
    
    if (imagenes == null) {
      imagenes = [];
    }

    final TextEditingController _tituloC =
        TextEditingController(text: tituloNota);
    final TextEditingController _contenidoC =
        TextEditingController(text: contenidoNota);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      //height: 500.0,
      color: Colors.white,
      child: loading == true
          ? const Center(
              child: SizedBox(
                  width: 30, height: 30, child: CircularProgressIndicator()))
          :
      SingleChildScrollView(
          // Se agrega esta linea para que se pueda ver todo el texto que se escribe en la nota
          child: Form(
              child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          genericTextFormField(_tituloC, "Título de la nota", false, 40),
          imagenes!.isEmpty
                    ? const Row()
                    : SizedBox(
                        height: 250,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: imagenes!.length,
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
                                            VerImagen(imagenes![index])));
                                setState(() {
                                  selectedImage = imagenes![index];

                                  if (indicador == "true") {
                                    imagenes!.remove(selectedImage);
                                  }
                                });
                              },
                              child: SizedBox(
                                //width: 400,
                                //height: 200,
                                child: Image.memory(imagenes![index]),
                              ),
                            );
                          },
                        ),
                      ),
          maxLinesTextFormField(_contenidoC, "Contenido", false, 2000),
          Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [PopupMenuButton(
  
  color: Colors.blue,
  icon: const Icon(Icons.add),

  itemBuilder: (BuildContext context) =><PopupMenuItem>[
    PopupMenuItem(
      child: Container(
        child:  Wrap(
          direction: Axis.horizontal,
          children: <Widget>[
            
            // Opcion de imagen a texto
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                child: const Icon(Icons.camera_alt),
                onTap: (){
                    tituloNota = _tituloC.text;
                    contenidoNota = _contenidoC.text;
                    getTextFromIa();
                },
                ),
              ),

            // Opcion de esbozar una nota
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                child: const Icon(Icons.draw),
                onTap: () async {
                  tituloNota = _tituloC.text;
                  contenidoNota = _contenidoC.text;
                  Uint8List? imagen = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DrawingRoomScreen()));
                  getEsbozado(imagen);

                },
                )
            ),

            // Opcion de voz a texto
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                child: const Icon(Icons.mic),
                onTap: () async {            
                  tituloNota = _tituloC.text;
                  contenidoNota = _contenidoC.text;
                  String espacio = " ";
                   String audio = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  SpeechScreen(text: '')));                    
                    showAudioToText(contenido: _contenidoC.text + audio + espacio,titulo: _tituloC.text );
                },
                )
            ),

            // Opcion de elegir imagen de la galeria
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                child: const Icon(Icons.photo),
                onTap: ()  {            
                    getFromGallery();
                    showAudioToText(contenido: _contenidoC.text ,titulo: _tituloC.text );
                },
                )
            ),
          ],
        ),
      )
    )
  ]
  )]),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  // Boton para editar la nota
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    backgroundColor: const Color.fromARGB(255, 99, 91, 250),
                  ),
                  onPressed: () async {
                    if (_tituloC.text != '') {
                      updateNota(_tituloC.text, _contenidoC.text);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Nota editada")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "El título de la nota no debe estar vacío")));
                    }
                  },
                  child: const Text("Editar")),
              const SizedBox(
                width: 15,
              ),
              ElevatedButton(
                  // Boton para eliminar la nota
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    backgroundColor: const Color.fromARGB(255, 99, 91, 250),
                  ),
                  onPressed: () {
                    showDialog(
                        //Ventana de advertencia para confirmar eliminar la nota
                        //Ventana de dialogo, aparece si el usuario ingresa mal sus datos
                        barrierDismissible: false,
                        context: context,
                        builder: (_) => AlertDialog(
                              title: const Text("Advertencia"),
                              content: const Text(
                                  "Esta seguro de que desea eliminar la nota?"), // Modificar el comentario de advertencia
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      /// Aqui se debe eliminar en la BD

                                      Navigator.pop(context);
                                      Navigator.of(context, rootNavigator: true)
                                          .pop('dialog');

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text("Nota eliminada")));
                                    },
                                    child: Text("Aceptar")),
                                TextButton(
                                    onPressed: () {
                                      regresarHome();
                                    },
                                    child: Text("Cancelar")),
                              ],
                            ));
                  },
                  child: const Text("Eliminar")),
              const SizedBox(
                width: 15,
              ),
              ElevatedButton(
                  // Boton para cancelar
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    backgroundColor: const Color.fromARGB(255, 99, 91, 250),
                  ),
                  onPressed: () {
                    Navigator.pop(context, 'refresh');
                  },
                  child: const Text("Cancelar"))
            ],
          ),
        ],
      ))),
    );
  }

  @override
  void dispose() {
    //_contenidoC.dispose();
    //_tituloC.dispose();
    super.dispose();
  }

  void regresarHome(){
    home.showNotes();
    Navigator.pop(context);
  }

    Future updateNota(String titulo, String contenido) async {
    setState(() {
      loading = true;
    });
    var response = await controller.updateNota(
      titulo: titulo, 
      contenido: contenido, 
      idNota: note.getid, 
      n_date: note.getDate,
      longitud: note.getLongitud,
      latitud: note.getLatitud,
      imagenes: imagenes);

    if (response.isLeft) {
      String text = '';
      text = response.left.message!;
      
      showSystemMessage(text);
      setState(() {
        loading = false;
      });
      
    }
    if (response.isRight) {

        home.showNotes();
        //Navigator.pop(context);
    }
  }

    showSystemMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
        contenidoNota = "${contenidoNota}\n${response.right}";
        loading = false;
      });
    }
  }

  void showAudioToText({required String contenido, required String titulo}) {
    setState(() {
      contenidoNota = contenido;
      tituloNota = titulo;
      loading = false;
    });
  }

  String getTitulo() {
    return tituloNota;
  }

  String getContenido() {
    return contenidoNota;
  }

  void getEsbozado(Uint8List? bytes) {
    if (bytes != null) {
      setState(() {
        imagenes!.add(bytes); // nuevo
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

        imagenes!.add(bytes);
      });
    }
  }
}



