import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../../domain/nota.dart';
import 'package:firstapp/infrastructure/views/editar_nota.dart';

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
          onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => 
          EditarNota(
            tituloNota: nota.titulo!, 
            contenidoNota: nota.contenido!, 
            imagenes: nota.imagenes
          )))
        ),      
      )
    ));   
  } 

  Widget getImage(){
   if ( nota.imagenes!.isEmpty ) {
      return Text('');
   }
    List<Uint8List> imagenes = nota.imagenes as List<Uint8List>;
    return CircleAvatar(
            radius: 35,
            backgroundImage: Image.memory(imagenes[0]).image
            );
  }
    
}

