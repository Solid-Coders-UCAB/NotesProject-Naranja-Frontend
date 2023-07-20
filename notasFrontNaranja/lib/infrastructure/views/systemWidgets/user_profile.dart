import 'package:firstapp/controllerFactory.dart';
import 'package:firstapp/infrastructure/views/systemWidgets/edit_user_profile.dart';
import 'package:firstapp/infrastructure/views/systemWidgets/navigationBar.dart';
import 'package:firstapp/infrastructure/views/systemWidgets/suscripcion.dart';
import 'package:firstapp/infrastructure/views/systemWidgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/domain/user.dart';
import '../../controllers/findUserByIdController.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  bool loading = false;
  findUserByIdController controller =
      controllerFactory.createfindUserByIdController();
  String nombre = "";
  String correo = "";
  String fechaNacimiento = "";
  String suscripcion = "";
  String idUsuario = "";
  String clave = "";
  DateTime fechaNacimientoDate = DateTime.now();

  void changeState(user u) {
    setState(() {
      loading = false;
      idUsuario = u.id;
      nombre = u.getNombre.toString();
      correo = u.getCorreo.toString();
      fechaNacimientoDate = u.getDate;
      print("nombre");
      clave = u.clave!;
      int dia = DateTime.parse(u.getDate.toString()).day;
      int mes = DateTime.parse(u.getDate.toString()).month;
      int year = DateTime.parse(u.getDate.toString()).year;
      fechaNacimiento = '$dia/ $mes / $year';
      if (u.getSuscripcion) {
        suscripcion = "Suscripción Premium";
      } else {
        suscripcion = "Suscripción Básica";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller.getUserById(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 103, 240),
        title: const Text("Perfil"),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: 'Menú',
            );
          },
        ),
      ),
      //Side Menu-------------------------------------
      drawer: NavBar(),
      body: loading == true
          ? const Center(
              child: SizedBox(
                  width: 30, height: 30, child: CircularProgressIndicator()))
          :SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: iconApp(120)),
              genericSizedBox(80),
              Text(
                'Nombre: $nombre',
                style: const TextStyle(fontSize: 20),
              ),
              genericSizedBox(50),
              Text(
                "Correo: $correo",
                style: const TextStyle(fontSize: 20),
              ),
              genericSizedBox(50),
              Text(
                "Fecha de nacimiento: $fechaNacimiento",
                style: const TextStyle(fontSize: 20),
              ),
              genericSizedBox(50),
              Text(
                "Suscripción: $suscripcion",
                style: const TextStyle(fontSize: 20),
              ),
              genericSizedBox(60),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Suscripcion(
                                idUsuario: idUsuario,
                                nombre: nombre,
                                correo: correo,
                                clave: clave,
                                fechaNacimiento: fechaNacimientoDate,
                              )));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 119, 255),
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  "Suscripción",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              genericSizedBox(50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditarPerfil(
                                idUsuario: idUsuario,
                                correo: correo,
                                nombre: nombre,
                                suscripcion: suscripcion,
                              )));
                },
                child: const Text(
                  "Editar Perfil",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 119, 255),
                  shape: const StadiumBorder(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
