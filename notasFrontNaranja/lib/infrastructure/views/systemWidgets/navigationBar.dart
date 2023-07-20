import 'package:firstapp/application/cerrarSesionService.dart';
import 'package:firstapp/controllerFactory.dart';

import 'package:firstapp/infrastructure/implementations/repositories/localUserRepository.dart';
import 'package:firstapp/infrastructure/views/folderWidgets/folderHome.dart';
import 'package:firstapp/infrastructure/views/etiquetasWidgets/etiquetasHome.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/home.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/map%20copy.dart';
import 'package:firstapp/infrastructure/views/recycleBinWidgets.dart/recycleBinHome.dart';
import 'package:firstapp/infrastructure/views/systemWidgets/inicio_sesion.dart';
import 'package:firstapp/infrastructure/views/systemWidgets/widgets.dart';
import 'package:firstapp/infrastructure/views/systemWidgets/user_profile.dart';
import 'package:flutter/material.dart';

// Ventana que contiene el menu lateral de opciones en la aplicacion
// ignore: must_be_immutable
class NavBar extends StatelessWidget {

  cerrarSesionService logOutService = cerrarSesionService(localRepo: localUserRepository());
  
  NavBar({super.key});

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

void accesoMapa(BuildContext context) async{
    var usuario = await controllerFactory.creategetUserByIdInServerService().execute(null);
    
    if (usuario.isRight) {

      if (usuario.right.isSuscribed) {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MyHomeMapScreen()));
      }else{
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("No posee suscripcion")));
      }
    }
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
                Icons.map,
                color: Color.fromARGB(255, 30, 103, 240),
              ),
              title: const Text('Mapa'),
              onTap: () {
                accesoMapa(context);
              },
            ),
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
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Color.fromARGB(255, 30, 103, 240),
              ),
              title: const Text('Cerrar sesion'),
              onTap: () async {
                  var response = await logOutService.execute(null);
                    if (response.isLeft){
                      alerta(context, false, 'login error', response.left.message!);
                  }else{
                    Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Inicio()),
                    (Route<dynamic> route) => false);
                  }
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.work_history,
                color: Color.fromARGB(255, 30, 103, 240),
              ),
              title: const Text('Sincronizar'),
              onTap: () async {
                  cargando(context, true, '', '');              
                  var response = await controllerFactory.createSincronizacionService().execute(null);
                    if (response.isLeft){
                      Navigator.pop(context);
                      alerta(context, false, 'error al sincronizar', response.left.message!);
                  }else{
                    Navigator.pop(context);
                    alerta(context, true, 'sincronizacion Exitosa', response.right!);
                  }
              },
            )
          ],
        ),
      );


}
