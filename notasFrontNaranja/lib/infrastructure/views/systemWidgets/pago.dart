import 'package:firstapp/controllerFactory.dart';
import 'package:firstapp/infrastructure/controllers/suscripcionNuevaController.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/home.dart';
import 'package:firstapp/infrastructure/views/systemWidgets/widgets.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PagoSuscripcion extends StatefulWidget {
  String idUsuario;
  String nombre;
  String correo;
  String clave;
  DateTime fechaNacimiento;
  PagoSuscripcion(
      {super.key,
      required this.idUsuario,
      required this.nombre,
      required this.correo,
      required this.clave,
      required this.fechaNacimiento});

  @override
  State<PagoSuscripcion> createState() => PagoSuscripcionState(
      idUsuario: idUsuario,
      nombre: nombre,
      correo: correo,
      clave: clave,
      fechaNacimiento: fechaNacimiento);
}

class PagoSuscripcionState extends State<PagoSuscripcion> {
  String idUsuario;
  String nombre;
  String correo;
  String clave;
  DateTime fechaNacimiento;
  PagoSuscripcionState(
      {required this.idUsuario,
      required this.nombre,
      required this.correo,
      required this.clave,
      required this.fechaNacimiento});

  crearSuscripcionController controller =
      controllerFactory.createdSuscripcionController();
  TextEditingController numeroTarjeta = TextEditingController(text: "");
  TextEditingController numeroCVC = TextEditingController(text: "");
  TextEditingController mesAnio = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 103, 240),
        title: const Text("Pago"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Center(child: iconApp(120)),
            genericSizedBox(100),
            genericTextFormField(numeroTarjeta, 'Numero de tarjeta', false, 20),
            genericTextFormField(numeroCVC, "CVC", false, 3),
            genericTextFormField(
                mesAnio, "Fecha de vencimiento MM/AA", false, 5),
            genericSizedBox(50),
            ElevatedButton(
                onPressed: () {
                  controller.updateUser(
                      idUsuario: idUsuario,
                      nombre: nombre,
                      correo: correo,
                      clave: clave,
                      fechaNacimiento: fechaNacimiento,
                      suscripcion: true);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const PaginaPrincipal()),
                      (Route<dynamic> route) => false);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 119, 255),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15)),
                child: const Text(
                  "Aceptar",
                  style: TextStyle(fontSize: 18),
                ))
          ],
        ),
      ),
    );
  }
}
