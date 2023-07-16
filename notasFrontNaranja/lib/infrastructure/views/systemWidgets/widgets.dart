import 'package:firstapp/infrastructure/views/noteWidgets/nota_nueva.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/drawing_room_screen.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/speech_to_text_prueba.dart';

// Widgets que se pueden reutilizar en varias interfaces

// Campo para escribir texto en una sola linea
Widget genericTextFormField(
    TextEditingController controllerData, String text, boolean, int maxLength) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: TextFormField(
      controller: controllerData,
      maxLength: maxLength,
      style: const TextStyle(
        color: Color.fromARGB(255, 0, 10, 147),
      ),
      obscureText: boolean,
      decoration: InputDecoration(
        //enabledBorder: OutlineInputBorder(
        //  borderRadius: BorderRadius.circular(30),
        //  borderSide: const BorderSide(
        //    color: Color.fromARGB(255, 154, 18, 255),
        //    width: 2,
        //  ),
        //),
        //focusedBorder: OutlineInputBorder(
        //  borderRadius: BorderRadius.circular(30),
        //  borderSide: const BorderSide(
        //    color: Color.fromARGB(255, 154, 18, 255),
        //    width: 2,
        //  ),
        // ),
        labelText: text,
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 90, 184, 255),
        ),
      ),
    ),
  );
}

// Campo para escribir texto en varias lineas
Widget maxLinesTextFormField(
    TextEditingController controllerData, String text, boolean, int maxLength) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: TextFormField(
      controller: controllerData,
      maxLength: maxLength,
      maxLines: null,
      style: const TextStyle(
        color: Color.fromARGB(255, 154, 181, 255),
      ),
      obscureText: boolean,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 154, 181, 255),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 154, 181, 255),
            width: 2,
          ),
        ),
        labelText: text,
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 154, 181, 255),
        ),
      ),
    ),
  );
}

Widget genericSizedBox(double size) {
  return SizedBox(
    height: size,
  );
}

Widget iconApp(double sizeIcon) {
  return Image.asset('assets/images/LogoSolo 1.png');
  // return Image.network(
  //   "https://cdn-icons-png.flaticon.com/512/1001/1001259.png",
  //   width: sizeIcon
  // );
}

Widget textLabel(String textInput, double fontSize) {
  return Text(
    textInput,
    style: TextStyle(
        color: Colors.black, fontSize: fontSize, fontWeight: FontWeight.bold),
  );
}

void alerta(BuildContext context, bool isGood, String title, String content) {
  IconData icon = isGood ? Icons.add_task_rounded : Icons.cancel_outlined;
  Color color = isGood ? Colors.green : Colors.red;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: 10),
            Text(title),
          ],
        ),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

// Widget que despliega un menu con las opciones adicionales que se pueden realizar en la nota (imagen a texto, esbozar y voz a texto)
Widget opcionesNota(NuevaNotaState state) {
  return PopupMenuButton(
      color: Colors.blue,
      icon: const Icon(Icons.add),
      itemBuilder: (BuildContext context) => <PopupMenuItem>[
            PopupMenuItem(
                child: Container(
              child: Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  // Opcion de imagen a texto
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      child: const Icon(Icons.camera_alt),
                      onTap: () {
                        state.getTextFromIa();
                      },
                    ),
                  ),

                  // Opcion de esbozar una nota
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        child: const Icon(Icons.draw),
                        onTap: () async {
                          Uint8List? imagen = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const DrawingRoomScreen()));
                          state.getEsbozado(imagen);
                        },
                      )),

                  // Opcion de voz a texto
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        child: const Icon(Icons.mic),
                        onTap: () async {
                          String espacio = " ";
                          String audio = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SpeechScreen(text: '')));
                          state.showAudioToText(
                              contenido: state.getContenido() + audio + espacio,
                              titulo: state.getTitulo());
                        },
                      )),

                  // Opcion de elegir imagen de la galeria
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        child: const Icon(Icons.photo),
                        onTap: () {
                          state.getFromGallery();
                        },
                      )),
                ],
              ),
            ))
          ]);
}
