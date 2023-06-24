import 'package:firstapp/infrastructure/views/nota_nueva.dart';
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
          onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => const NotaNueva()))
        ) 
    )));   
  } 
    
}

