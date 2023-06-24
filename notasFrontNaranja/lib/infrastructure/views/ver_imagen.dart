import 'package:flutter/foundation.dart';
// ignore_for_file: must_be_immutable
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerImagen extends StatelessWidget {
  Uint8List? bytes;
  VerImagen(this.bytes, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            Navigator.pop(context, "false"); 
          },
        ),
        title: const Text(""),
        backgroundColor: Colors.blue,
      ),
      body:  Center(
        child: Imagen(bytes),
      ),
      floatingActionButton: FloatingActionButton( //boton para probar backend
            heroTag: 'delete_image',
            onPressed: () {
                  Navigator.pop(context, "true");
            },
            tooltip: 'Delete',
            child: const Icon(Icons.delete),
          ),
    );
  }
}

class Imagen extends StatefulWidget {
Uint8List? bytes;
  Imagen(this.bytes, {super.key});

  @override
  // ignore: no_logic_in_create_state
  State<Imagen> createState() => _ImagenState(bytes);
}

class _ImagenState extends State<Imagen> {
  Uint8List? bytes;

  _ImagenState(this.bytes);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      //height: 500.0,
      color: Colors.white,
      child: ListView(children: [if(bytes != null) Image.memory(bytes!), ],)
    );
  }


}

