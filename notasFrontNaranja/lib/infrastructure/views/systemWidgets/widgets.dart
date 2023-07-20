

import 'package:flutter/material.dart';


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
  return Image.asset(
    'assets/images/LogoSolo 1.png',
    width: sizeIcon,
  );
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


void cargando(BuildContext context, bool isGood, String title, String content) {
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
            const SizedBox(width: 10),
            const Text("Cargando.."),
          ],
        ),
        content: const SizedBox(
                  width: 30, height: 30, child: CircularProgressIndicator()),
      );
    },
  );
}

