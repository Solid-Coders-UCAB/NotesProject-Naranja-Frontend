import 'package:flutter/material.dart';

import './widgets.dart';

class NotaNueva extends StatelessWidget {

  const NotaNueva({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nueva nota"),
        backgroundColor: const Color.fromARGB(255, 99, 91, 250),
      ),
      body: const Center(
        child: NuevaNota(),
      ),
    );
  }
}

class NuevaNota extends StatefulWidget {
  const 
  NuevaNota({
    super.key,
  });

  @override
  State<NuevaNota> createState() => _NuevaNotaState();
}

class _NuevaNotaState extends State<NuevaNota> {

 String noteContent = '';
 String noteTitle = '';
  
  final TextEditingController _tituloC = TextEditingController(text: "hola");
  final TextEditingController _contenidoC = TextEditingController(text: "");


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      //height: 500.0,
      color: Colors.white,
      child: SingleChildScrollView(
          // Se agrega esta linea para que se pueda ver todo el texto que se escribe en la nota
          child: Form(
              child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          genericTextFormField(_tituloC, "Título de la nota", false, 40),
          genericTextFormField(
              _contenidoC, "Contenido de la nota", false, 2000),
          //     2000, // Aqui se indica el maximo de caracteres que se pueden ingresar a la nota
          // TextFormField(
          // controller: _contenidoC,
          // decoration: const InputDecoration(labelText: "Contenido"),
          // maxLength:

          /// Para determinar el maximo de lineas que puede tener el campo de texto del cuerpo de la nota
          // maxLines: null,
          //initialValue: "contenido de la nota",  //Aqui se debe cargar el contenido de la nota de la base de datos
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    backgroundColor: const Color.fromARGB(255, 99, 91, 250),
                  ),
                  onPressed: () {
                    if (_tituloC.text != '') {

                      cambiarTituloC();


                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Nota agregada")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "El título de la nota no debe estar vacía")));
                    }
                  },
                  child: const Text("Aceptar")),
              const SizedBox(
                width: 15,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 99, 91, 250),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  onPressed: () {
                 
                  },
                  child: const Text("Cancelar"))
            ],
          ),
        ],
      ))),
    );
  }

   cambiarTituloC() {
    setState(() {
      print('paso');
      _tituloC.text = "jijija";
    });
  }

}



