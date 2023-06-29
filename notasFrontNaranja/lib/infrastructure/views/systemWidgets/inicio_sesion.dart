import 'package:flutter/material.dart';
import '../noteWidgets/home.dart';
import 'widgets.dart';

class App extends StatelessWidget{
  
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(         
        primarySwatch: Colors.blue,
      ),
      home: const Inicio(),
    );
  }
}


class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {

  TextEditingController userText = TextEditingController(text: "");
  TextEditingController userPass = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return 
     Scaffold(
      body: bodyInicio(), // Se pasa context como parametro
    );
  }

  Widget botonEntrar(TextEditingController userText,
    TextEditingController userPass) {
  //Se agrega el argumento context
  return TextButton(
      style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          backgroundColor: const Color.fromARGB(255, 154, 181, 255),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10)),
      onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
            builder: (context) =>  PaginaPrincipal()));

        //alerta(context,true,"Wrong Password","The password didnt match");
        ///Envia al usuario a la ventana de inicio
      }, // Funcion para cuando se presione el boton (se debe validar el usuario que va a ingresar para ver sus notas)
      child: const Text(
        "Ingresar",
        style: TextStyle(fontSize: 25, color: Colors.white),
      ));
}




Widget bodyInicio() {
  
  return Container(
    height: double.infinity,
    decoration: const BoxDecoration(
        //Fondo
        gradient: LinearGradient(
      colors: [
        Color.fromARGB(255, 203, 200, 255),
        Color.fromARGB(255, 168, 245, 255)
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      transform: GradientRotation(90),
    )),
    child: Transform.translate(
      //Acomodar la ubicacion inicial
      offset: const Offset(0, 70),
      child: SingleChildScrollView(
        //Evitar el error BottomOverflowed
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            iconApp(120),
            genericSizedBox(30),
            Card(
              shape: RoundedRectangleBorder(
                  side: const BorderSide(
                      color: Color.fromARGB(136, 112, 180, 192), width: 3),
                  borderRadius: BorderRadius.circular(25)),
              color: const Color.fromARGB(255, 255, 255, 255),
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(children: <Widget>[
                  textLabel("Iniciar sesión", 30),
                  genericSizedBox(20),
                  genericTextFormField(userText, "Usuario", false, 20),
                  genericSizedBox(25),
                  genericTextFormField(userPass, "Contraseña", true, 20),
                  genericSizedBox(25),
                  botonEntrar(userText,userPass),
                  genericSizedBox(25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textLabel("¿No tienes una cuenta?", 15),
                      TextButton(
                          onPressed: () {
                           // Navigator.push(
                            //    context,
                            //    MaterialPageRoute(
                               //     builder: (context) => const Registro()));
                          },
                          child: const Text(
                            "Crear cuenta",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.cyan,
                                fontSize: 15),
                          ))
                    ],
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
}


