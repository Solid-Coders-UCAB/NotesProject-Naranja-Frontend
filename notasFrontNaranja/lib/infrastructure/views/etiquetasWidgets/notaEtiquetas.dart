
// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class notaEtiquetas extends StatelessWidget {

  const notaEtiquetas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Etiquetas"),
        backgroundColor: const Color.fromARGB(255, 99, 91, 250),
        leading: IconButton(
            icon:  const Icon(Icons.transit_enterexit_outlined),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: const etiquetasNota(),
    );
  }
}

class etiquetasNota extends StatefulWidget {

  const etiquetasNota({super.key});

  @override
  State<etiquetasNota> createState() => etiquetasNotaState();
}

class etiquetasNotaState extends State<etiquetasNota> {
  
  
  @override
  Widget build(BuildContext context) {
    return const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.save),
            title: Text('ETIQUETAS AGREGADAS'),
            subtitle: Card(),
          )
        ]
    );  
  }
  
}


