import 'dart:typed_data';

import 'package:firstapp/infrastructure/views/nota_nueva.dart';
import 'package:firstapp/infrastructure/views/ver_imagen.dart';
import 'package:flutter/material.dart';

import '../../../domain/nota.dart';

class notePreviewWidget extends StatelessWidget{

  final Nota nota;

  const notePreviewWidget({super.key,required this.nota});
     
  @override
  Widget build(BuildContext context) {


    return(Card(
      child: 
      Material(
        child: ListTile(
          title: Text(nota.getTitulo),
          subtitle: Text(nota.getContenido),
          onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => const NotaNueva())),
          leading: getImage(),
        ),      
      )
    ));   
  } 

  Widget getImage(){
   if ( nota.imagenes!.isEmpty ) {
      print(nota.getContenido);
      return Text('');
   }
    List<Uint8List> imagenes = nota.imagenes as List<Uint8List>;
    return CircleAvatar(
            radius: 100,
            backgroundImage: Image.memory(imagenes[0]).image
            );
  }
    
}

