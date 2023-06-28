import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../../domain/nota.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/editar_nota.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/home.dart';

class notePreviewWidget extends StatelessWidget{

  final Nota nota;
  final homeState home;
  const notePreviewWidget({super.key,required this.nota, required this.home});
     
  @override
  Widget build(BuildContext context) {


    return(Card(
      child: 
      Material(
        child: ListTile(
          title: Text(nota.getTitulo),
          subtitle: Text("ultima actualizacion: ${nota.getEditDate}"),
          leading: getImage(),
          onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => 
          EditarNota(
            tituloNota: nota.titulo!, 
            contenidoNota: nota.contenido!, 
            imagenes: nota.imagenes,
            note: nota,
            h: home,
          )))
        ),      
      )
    ));   
  } 


  Widget getImage(){
   if ( nota.imagenes!.isEmpty ) {
      return const CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white38,
            child: Icon(Icons.note_rounded)
            );
   }
    List<Uint8List> imagenes = nota.imagenes as List<Uint8List>;
    return CircleAvatar(
            radius: 35,
            backgroundImage: Image.memory(imagenes[0]).image
            );
  }
    
}

