import 'package:firstapp/infrastructure/views/systemWidgets/widgets.dart';
import 'package:flutter/material.dart';

class PagoSuscripcion extends StatefulWidget {
  const PagoSuscripcion({super.key});

  @override
  State<PagoSuscripcion> createState() => _PagoSuscripcionState();
}

class _PagoSuscripcionState extends State<PagoSuscripcion> {
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
                onPressed: () {},
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
