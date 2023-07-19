import 'package:flutter/material.dart';
import 'package:firstapp/infrastructure/views/systemWidgets/widgets.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  TextEditingController userText = TextEditingController(text: "");
  TextEditingController userPass = TextEditingController(text: "");
  TextEditingController userName = TextEditingController(text: "");
  DateTime date = DateTime(2023, 01, 01);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 103, 240),
        title: const Text("Editar Perfil"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Center(child: iconApp(120)),
              genericSizedBox(80),
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
                        )),
                    genericSizedBox(50),
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            backgroundColor:
                                const Color.fromARGB(255, 30, 103, 240)),
                        child: const Text(
                          'Editar',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
