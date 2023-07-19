import 'package:firstapp/infrastructure/views/folderWidgets/folderHome.dart';
import 'package:firstapp/infrastructure/views/etiquetasWidgets/etiquetasHome.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/home.dart';
import 'package:firstapp/infrastructure/views/recycleBinWidgets.dart/recycleBinHome.dart';
import 'package:firstapp/infrastructure/views/systemWidgets/user_profile.dart';
import 'package:flutter/material.dart';

// Ventana que contiene el menu lateral de opciones en la aplicacion
class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(25),
        child: Wrap(
          runSpacing: 15,
          children: [
            // Home de notas (ventana principal)
            ListTile(
              leading: const Icon(
                Icons.home_rounded,
                color: Color.fromARGB(255, 30, 103, 240),
              ),
              title: const Text('Inicio'),
              onTap: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Home(),
              )),
            ),
            // Home de carpetas
            ListTile(
              leading: const Icon(
                Icons.folder_rounded,
                color: Color.fromARGB(255, 30, 103, 240),
              ),
              title: const Text('Carpetas'),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => folderHome()),
                    (Route<dynamic> route) => false);
              },
            ),
            // Home de etiquetas
            ListTile(
              leading: const Icon(
                Icons.label_rounded,
                color: Color.fromARGB(255, 30, 103, 240),
              ),
              title: const Text('Etiquetas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const etiquetasHome()));
              },
            ),
            // Ventana de papelera para las notas eliminadas
            ListTile(
              leading: const Icon(
                Icons.delete_rounded,
                color: Color.fromARGB(255, 30, 103, 240),
              ),
              title: const Text('Papelera'),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const recycleBinHome()),
                    (Route<dynamic> route) => false);
              },
            ),
            const Divider(
              color: Color.fromRGBO(114, 114, 114, 1),
            ),
            // Ventana de perfil del usuario
            ListTile(
              leading: const Icon(
                Icons.account_circle,
                color: Color.fromARGB(255, 30, 103, 240),
              ),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const UserProfile()));
              },
            )
          ],
        ),
      );
}
