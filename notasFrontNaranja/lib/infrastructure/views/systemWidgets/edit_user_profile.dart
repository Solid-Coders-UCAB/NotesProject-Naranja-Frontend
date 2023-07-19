import 'package:firstapp/controllerFactory.dart';
import 'package:firstapp/infrastructure/controllers/editarUsuarioWidgetController.dart';
import 'package:firstapp/infrastructure/views/systemWidgets/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/infrastructure/views/systemWidgets/widgets.dart';

class EditarPerfil extends StatefulWidget {
  String idUsuario;
  String nombre;
  String correo;
  String suscripcion;
  EditarPerfil(
      {super.key,
      required this.idUsuario,
      required this.correo,
      required this.nombre,
      required this.suscripcion});

  @override
  State<EditarPerfil> createState() =>
      // ignore: no_logic_in_create_state
      EditarPerfilState(
          idUsuario: idUsuario,
          nombre: nombre,
          correo: correo,
          suscripcion: suscripcion);
}

class EditarPerfilState extends State<EditarPerfil> {
  String idUsuario;
  String nombre;
  String correo;
  String suscripcion;
  EditarPerfilState(
      {required this.idUsuario,
      required this.correo,
      required this.nombre,
      required this.suscripcion});
  DateTime date = DateTime(2023, 01, 01);
  editarUsuarioWidgetController controller =
      controllerFactory.createEditarUsuarioWidgetController();
  @override
  Widget build(BuildContext context) {
    TextEditingController userCorreo = TextEditingController(text: correo);
    TextEditingController userPass = TextEditingController(text: "");
    TextEditingController userName = TextEditingController(text: nombre);
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
              Text(
                'Fecha de nacimiento: ${date.year}-${date.month}-${date.day}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 90, 184, 255),
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      foregroundColor: Colors.black,
                      backgroundColor: const Color.fromARGB(255, 30, 103, 240),
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
              genericSizedBox(5),
              genericTextFormField(userName, "Nombre", false, 40),
              genericTextFormField(userCorreo, "Correo", false, 50),
              genericTextFormField(userPass, "Contraseña", true, 20),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    genericSizedBox(50),
                    ElevatedButton(
                        onPressed: () {
                          if ((userName.text != "") &&
                              (userCorreo != "") &&
                              (userPass != "") &&
                              (date != DateTime(2023, 01, 01))) {
                            if (suscripcion == "Suscripción Premium") {
                              updateUsuario(idUsuario, userName.text,
                                  userCorreo.text, userPass.text, date, true);
                            } else {
                              updateUsuario(idUsuario, userName.text,
                                  userCorreo.text, userPass.text, date, false);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            backgroundColor:
                                const Color.fromARGB(255, 30, 103, 240)),
                        child: const Text(
                          'Editar',
                          style: TextStyle(color: Colors.white, fontSize: 20),
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

  showSystemMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

// Funcion para editar una carpeta
  updateUsuario(String idUsuario, String nombre, String correo, String clave,
      DateTime fechaNacimiento, bool suscripcion) async {
    // Se llama a la funcion del controlador para editar la etiqueta
    var response = await controller.updateUser(
        idUsuario: idUsuario,
        nombre: nombre,
        correo: correo,
        clave: clave,
        fechaNacimiento: fechaNacimiento,
        suscripcion: suscripcion);

    if (response.isLeft) {
      String text = '';
      text = response.left.message!;
      showSystemMessage(text);
    }
    if (response.isRight) {
      showSystemMessage('Datos actualizados correctamente');

      // Se regresa a la ventana de HomeEtiqueta
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const UserProfile()),
          (Route<dynamic> route) => false);
    }
  }
}
