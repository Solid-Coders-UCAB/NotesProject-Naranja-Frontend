import 'package:firstapp/infrastructure/views/systemWidgets/inicio_sesion.dart';
import 'package:firstapp/infrastructure/views/systemWidgets/widgets.dart';
import 'package:flutter/material.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  TextEditingController userText = TextEditingController(text: "");
  TextEditingController userPass = TextEditingController(text: "");
  TextEditingController userName = TextEditingController(text: "");
  DateTime date = DateTime(2023, 01, 01);

  //TextEditingController confirmPass = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        //Evitar el error BottomOverflowed
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            genericSizedBox(50),
            iconApp(120),
            genericSizedBox(30),
            Card(
              shape: RoundedRectangleBorder(
                  side: const BorderSide(
                      color: Color.fromARGB(255, 30, 103, 240), width: 3),
                  borderRadius: BorderRadius.circular(25)),
              color: const Color.fromARGB(255, 255, 255, 255),
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(children: <Widget>[
                  textLabel("Crear cuenta", 30),
                  genericTextFormField(userText, "Correo", false, 50),
                  genericTextFormField(userName, "Nombre", false, 40),
                  genericTextFormField(userPass, "Contraseña", true, 20),
                  genericSizedBox(5),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Fecha de nacimiento: ${date.year}-${date.month}-${date.day}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 90, 184, 255),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                foregroundColor: Colors.black,
                                backgroundColor:
                                    const Color.fromARGB(255, 30, 103, 240),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10)),
                            onPressed: () async {
                              DateTime? newDate = await showDatePicker(
                                  context: context,
                                  initialDate: date,
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2023));
                              //Si selecciona 'CANCEL'
                              if (newDate == null) return;
                              //Si selecciona 'OK'
                              setState(() {
                                date = newDate;
                              });
                            },
                            child: const Text(
                              'Seleccionar fecha de nacimiento',
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                  ),
                  genericSizedBox(20),
                  //genericTextFormField(userPass, "Confirm Password", true),
                  //genericSizedBox(25),
                  botonOk(context, userText, userPass, userName, date),
                  genericSizedBox(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textLabel("¿Ya tienes una cuenta?", 15),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Inicio()));
                          },
                          child: const Text(
                            "Iniciar sesión",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 119, 255),
                                fontSize: 15),
                          ))
                    ],
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
      // Se pasa context como parametro
    );
  }
}

Widget botonOk(
    BuildContext context,
    TextEditingController userText,
    TextEditingController userPass,
    TextEditingController userName,
    DateTime? date) {
  //Se agrega el argumento context
  return TextButton(
      style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          foregroundColor: Colors.black,
          backgroundColor: const Color.fromARGB(255, 30, 103, 240),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10)),
      onPressed: () {
        //createRequest(userText.text, userPass.text, context);
        // Registrar
      },
      child: const Text(
        "Crear",
        style: TextStyle(fontSize: 25, color: Colors.white),
      ));
}
