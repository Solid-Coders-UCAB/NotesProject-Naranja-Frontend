import 'package:firstapp/infrastructure/views/systemWidgets/pago.dart';
import 'package:firstapp/infrastructure/views/systemWidgets/widgets.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Suscripcion extends StatefulWidget {
  String idUsuario;
  String nombre;
  String correo;
  String clave;
  DateTime fechaNacimiento;
  Suscripcion(
      {super.key,
      required this.idUsuario,
      required this.nombre,
      required this.correo,
      required this.clave,
      required this.fechaNacimiento});

  @override
  // ignore: no_logic_in_create_state
  State<Suscripcion> createState() => SuscripcionState(
      idUsuario: idUsuario,
      nombre: nombre,
      correo: correo,
      clave: clave,
      fechaNacimiento: fechaNacimiento);
}

class SuscripcionState extends State<Suscripcion> {
  String idUsuario;
  String nombre;
  String correo;
  String clave;
  DateTime fechaNacimiento;
  SuscripcionState(
      {required this.idUsuario,
      required this.nombre,
      required this.correo,
      required this.clave,
      required this.fechaNacimiento});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 103, 240),
        title: const Text("Suscripción"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(child: iconApp(120)),
              genericSizedBox(100),
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 30, 103, 240)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                        color: Color.fromARGB(
                                            255, 30, 103, 240))))),
                    child: const Text(
                      "Suscripción Gratuita",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const Text(
                    "Beneficios",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  genericSizedBox(10),
                  const Text("Funciones básicas"),
                  genericSizedBox(100),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PagoSuscripcion(
                                    idUsuario: idUsuario,
                                    nombre: nombre,
                                    correo: correo,
                                    clave: clave,
                                    fechaNacimiento: fechaNacimiento,
                                  )));
                    },
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 30, 103, 240)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                        color: Color.fromARGB(
                                            255, 30, 103, 240))))),
                    child: const Text(
                      "Suscripción Premium",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const Text(
                    "Beneficios",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  genericSizedBox(10),
                  const Text("Notas con Geolocalización"),
                  const Text("Captura de texto mediante la cámara"),
                  const Text("Voz a texto"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
