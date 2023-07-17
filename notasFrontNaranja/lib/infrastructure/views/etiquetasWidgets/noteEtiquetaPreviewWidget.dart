// ignore_for_file: no_logic_in_create_state
import 'dart:typed_data';
import 'package:firstapp/controllerFactory.dart';
import 'package:firstapp/infrastructure/controllers/notePreviewController.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/editarNotaEditor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

import '../../../domain/etiqueta.dart';
import '../../../domain/nota.dart';
import 'package:firstapp/infrastructure/views/etiquetasWidgets/notasPorEtiqueta.dart';

class noteEtiquetaPreviewWidget extends StatefulWidget{

  final Nota nota;
  final NotasEtiquetaState home;
  const noteEtiquetaPreviewWidget({super.key,required this.nota, required this.home});

    @override
    State<noteEtiquetaPreviewWidget> createState() => noteEtiquetaPreviewWidgetState(nota: nota);

}

class noteEtiquetaPreviewWidgetState extends State<noteEtiquetaPreviewWidget> {

  Nota nota;
  notePreviewController controller = controllerFactory.createNotePreviewController();
  noteEtiquetaPreviewWidgetState({required this.nota});
  List<etiqueta> tags = [];
  bool loadingTags = false;

  @override
  void initState() {
    super.initState();
     setState(() {
       loadingTags = true;
     });
     init();
  }

  void init() async{
   var controllerResponse =  await controller.getAllTagsNote(nota);
    if (controllerResponse.isRight){
      setState(() {
        loadingTags = false;
      });
      tags = controllerResponse.right.etiquetas!;
    }else{
      print(controllerResponse.left.message);
    }
     
  } 
  
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
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("ultima actualizacion: ${nota.getEditDate}"
          ),
          loadingTags == false ?
          Tags(  
            itemCount: tags.length, 
            itemBuilder: (int index){ 
              return Tooltip(
                message: tags[index].nombre,
                child: ItemTags(
                  title: tags[index].nombre, index: index,
                  pressEnabled: true,
               )   
             );
            } 
          )
          :
          const Text('cargando etiquetas...')
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
