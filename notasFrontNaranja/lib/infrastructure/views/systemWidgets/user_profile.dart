import 'package:firstapp/infrastructure/views/systemWidgets/edit_user_profile.dart';
import 'package:firstapp/infrastructure/views/systemWidgets/navigationBar.dart';
import 'package:firstapp/infrastructure/views/systemWidgets/suscripcion.dart';
import 'package:firstapp/infrastructure/views/systemWidgets/widgets.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: iconApp(120)),
              genericSizedBox(80),
              Text(
                'Nombre:',
                style: TextStyle(fontSize: 20),
              ),
              genericSizedBox(50),
              Text(
                "Correo:",
                style: TextStyle(fontSize: 20),
              ),
              genericSizedBox(50),
              Text(
                "Fecha de nacimiento:",
                style: TextStyle(fontSize: 20),
              ),
              genericSizedBox(50),
              Text(
                "Suscripción:",
                style: TextStyle(fontSize: 20),
              ),
              genericSizedBox(60),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Suscripcion()));
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
                          builder: (context) => const EditarPerfil()));
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
