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
          subtitle: getImage(),
          onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => const NotaNueva()))
        ),      
      )
    ));   
  } 

  Widget getImage(){
   if ( nota.imagenes!.isEmpty ) {
      print(nota.getContenido);
      return Text(nota.getContenido);
   }
    List<Uint8List> imagenes = nota.imagenes as List<Uint8List>;
    return Column(
            children:[ Image.memory(imagenes[0],scale: 1,fit: BoxFit.cover),
                       imagenes.length > 1 ? Image.memory(imagenes[1],scale: 1,fit: BoxFit.cover) : Text('HOLA')
              ]
            );
  }
    
}

