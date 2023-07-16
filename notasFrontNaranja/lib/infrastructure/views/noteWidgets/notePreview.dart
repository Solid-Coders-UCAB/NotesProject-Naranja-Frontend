
import 'dart:typed_data';
import 'package:firstapp/infrastructure/views/noteWidgets/editarNotaEditor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

import '../../../domain/nota.dart';
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
          subtitle: subtituloNota(),
          leading: getImage(),
          onTap: () => 
          Navigator.push(context,MaterialPageRoute(builder: (context) => 
          HtmlEditorEditar(nota: nota)))
        ),      
      )
    ));   
  }

  Widget subtituloNota(){
     List<String> tagsList = ['apple', 'banana', 'orange', 'kiwi'];
    List<String> selectedTags = [];
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("ultima actualizacion: ${nota.getEditDate}"
          ),
          Tags(  
            itemCount: tagsList.length, 
            itemBuilder: (int index){ 
              return Tooltip(
                message: tagsList[index],
                child: ItemTags(
                  title: tagsList[index], index: index,
                  pressEnabled: true,
               )   
             );
            } 
          )
        ] 
       );
  }



  Widget getImage(){
   Uint8List? image = nota.getFirstImage(); 
   if (image == null){ 
      return const CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white38,
            child: Icon(Icons.note_rounded)
            );
   }
    return CircleAvatar(
            radius: 35,
            backgroundImage: Image.memory(image).image
            );
  }
    
}

