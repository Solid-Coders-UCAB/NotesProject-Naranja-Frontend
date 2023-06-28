import 'package:firstapp/infrastructure/views/folderWidgets/folderHome.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/home.dart';
import 'package:firstapp/infrastructure/views/recycleBinWidgets.dart/recycleBinHome.dart';
import 'package:flutter/material.dart';

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
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Inicio'),
              onTap: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Home(),
              )),
            ),
            ListTile(
              leading: const Icon(Icons.folder_outlined),
              title: const Text('Carpetas'),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                 builder: (context) => folderHome()),(Route<dynamic> route) => false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.label_outline),
              title: const Text('Etiquetas'),
              onTap: () {
                Navigator.pop(context);
                //Navigator.of(context).push(MaterialPageRoute(
                //  builder: (context) => Pagina a llamar));
              },
            ),
            ListTile(
              leading: const Icon(Icons.cleaning_services_rounded),
              title: const Text('Papelera'),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                 builder: (context) => const recycleBinHome()),(Route<dynamic> route) => false);
              },
            ),
            const Divider(
              color: Color.fromRGBO(114, 114, 114, 1),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle_outlined),
              title: const Text('Perfil'),
              onTap: () {
                //Navigator.of(context).pushReplacement(MaterialPageRoute(
                //  builder: (context) => Pagina a llamar));
              },
            )
          ],
        ),
      );
}
