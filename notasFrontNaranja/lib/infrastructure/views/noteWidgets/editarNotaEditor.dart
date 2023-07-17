// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:firstapp/controllerFactory.dart';
import 'package:firstapp/infrastructure/controllers/editarNotaWidgetController.dart';
import 'package:firstapp/infrastructure/controllers/notaNuevaWidgetController.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/home.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/speech_to_text_prueba.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:file_picker/file_picker.dart';

import '../../../domain/etiqueta.dart';
import '../../../domain/nota.dart';
import '../systemWidgets/widgets.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/drawing_room_screen.dart';
import 'package:path_provider/path_provider.dart';

class HtmlEditorEditar extends StatelessWidget {

  Nota nota;
  
  HtmlEditorEditar({super.key,required this.nota});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar nota"),
        backgroundColor: const Color.fromARGB(255, 99, 91, 250),
        leading: IconButton(
            icon: Icon(Icons.transit_enterexit_outlined),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: HtmlEditorExample(nota: nota),
    );
  }

} 

class HtmlEditorExample extends StatefulWidget {

  Nota nota;
  
  HtmlEditorExample({super.key,required this.nota});

  @override
  HtmlEditorEditExampleState createState() => HtmlEditorEditExampleState(nota: nota );
}

class HtmlEditorEditExampleState extends State<HtmlEditorExample> {  
  Nota nota;
  bool loading = false;

  final editarNotaWidgetController controller = controllerFactory.editarNotaWidController();

  final HtmlEditorController editorC = HtmlEditorController();
  final TextEditingController tituloC = TextEditingController();

  List<etiqueta> tagsList = [];
  List<etiqueta> selectedTags = [];
  List<etiqueta> oldTags = [];
  
  HtmlEditorEditExampleState({required this.nota});

  @override
  void initState() {
    super.initState();
      setState(() {
        loading = true;
      });
    init();
  }
  void init() async {
    var controllerResponse = await controller.getAllEtiquetas();
      if (controllerResponse.isLeft){
           showSystemMessage(controllerResponse.left.message);
      }
      setState(() {
        loading = false;
      });
     tagsList = controllerResponse.right;     
  }



  @override
  Widget build(BuildContext context) {
    tituloC.text = nota.titulo;
    return
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      color: Colors.white,
      child: loading == true
          ? const Center(
              child: SizedBox(
                  width: 30, height: 30, child: CircularProgressIndicator()))
    : 
      SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child:
      //  Form(
      //    child:
          Column( 
            children: [
              genericTextFormField(tituloC, "Título de la nota", false, 40),
              htmlEditor()
          ]       
      )
   // )
   )
  );
 }

 Widget htmlEditor(){
  return HtmlEditor(
                controller: editorC, //required
                htmlEditorOptions: HtmlEditorOptions(
                initialText: nota.contenido,
                hint: 'recuperando contenido...'      
              ),
              htmlToolbarOptions: HtmlToolbarOptions(
              toolbarPosition: ToolbarPosition.belowEditor, //by default
              toolbarType: ToolbarType.nativeScrollable,
              renderBorder: false,
              customToolbarButtons: [
                ElevatedButton(onPressed: () {
                 showBottomSheet(context: context, builder: (context) => menuOpciones());
                }, child: const Icon(Icons.add))             
              ],
              mediaUploadInterceptor: fileInterceptor
              ), //
              otherOptions: OtherOptions(
              height: 550,
              decoration: BoxDecoration()
              ),
            );
 }


 FutureOr<bool> fileInterceptor(PlatformFile file, InsertFileType type) async {
  if (type == InsertFileType.image) {
                String base64Data = base64.encode(file.bytes!);
                String base64Image =
                """<img src="data:image/${file.extension};base64,$base64Data" data-filename="${file.name}" width="300" height="300"/>""";
                editorC.insertHtml(base64Image);
              }
   return false; 
 }

void regresarHome(){
  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
  builder: (context) => Home()),(Route<dynamic> route) => false);
}

void editarNota() async {
  
  String text = await editorC.getText();
  setState(() {
    loading = true;
  });
  var controllerResponse = await controller.updateNota(
    titulo: tituloC.text, contenido: text, idCarpeta: nota.idCarpeta, idNota: nota.id, n_date: nota.n_date, etiquetas: selectedTags ); 
  if (controllerResponse.isLeft){
    showSystemMessage(controllerResponse.left.message);
  }else{
     showSystemMessage('nota guardada satisfactoriamente');
     regresarHome();
  }
}

void eliminarNota() async {
  
  String text = await editorC.getText();
    controller.eliminarNotaAction1( widget: this,
    titulo: tituloC.text, contenido: text, idCarpeta: nota.idCarpeta, id: nota.id, n_date: nota.n_date); 
}

void imageToText() async {
  var controllerResponse = await controller.showTextFromIA();
  String text = controllerResponse.right;  
  if (controllerResponse.isLeft){
    showSystemMessage(controllerResponse.left.message);
  }else{
    print(text);
     editorC.setText(await editorC.getText()+text);
    print(await editorC.getText());

  }
}

void voiceToText() async {
  String espacio = " ";
  String audio = await Navigator.push(
   context,
   MaterialPageRoute(builder: (context) =>  SpeechScreen(text: '')));                    
  editorC.setText(await editorC.getText() + espacio + audio);
}

// Funcion para insertar el esbozado en el cuerpo de la nota
 void esbozado(PlatformFile file) async {
    String base64Data = base64.encode(file.bytes!);
    String base64Image =
      """<img src="data:image/${file.extension};base64,$base64Data" data-filename="${file.name}" width="300" height="300"/>""";
    editorC.insertHtml(base64Image);
        
 }
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  
  return directory.path;
}
void showSystemMessage(String? message){
    setState(() {
      loading = false;
    });
     ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message!)));
  }

Widget menuOpciones() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.save),
            title: Text('Guardar cambios'),
            onTap: () async {
              Navigator.pop(context);     
              editarNota();    
            },
          ),
          ListTile(
            leading: Icon(Icons.save),
            title: Text('Eliminar nota'),
            onTap: () {
              Navigator.pop(context);     
              eliminarNota();    
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app_rounded),
            title: Text('Cancelar'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
           ListTile(
            leading: const Icon(Icons.tag),
            title: Text('Etiquetas'),
            onTap: () {
              Navigator.pop(context);
              selectedTags = [];
              showBottomSheet(context: context, builder: (context) => menuEtiquetas());
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: Text('Agregar ubicacion'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.record_voice_over_rounded),
            title: Text('Voz a texto'),
            onTap: () {
              Navigator.pop(context);
              voiceToText();
            },
          ),
          ListTile(
            leading: const Icon(Icons.draw),
            title: Text('Esbozar'),
            onTap: () async
             {
              Navigator.pop(context);

              Uint8List? imagen = await Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => const DrawingRoomScreen()));
              if (imagen != null) {
                try {
                  final appStorage = await _localPath;
                  int randomNumber = Random().nextInt(10000);
                  String imageName = 'image$randomNumber';
                  final archivo = File('$appStorage/$imageName.png');
                  archivo.writeAsBytes(imagen); 

                  PlatformFile file = PlatformFile(
                    name: imageName,
                    bytes: imagen,
                    path: archivo.path, 
                    size: 0,
                  );
                  esbozado(file);
                } catch (e) {
                //print("error guardando imagen ${e}");
                }
                
                }
            },
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: Text('Imagen a texto'),
            onTap: () {
              Navigator.pop(context);
              imageToText();  
            },
          ),
        ],
      );
  }

  Widget menuEtiquetas() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.exit_to_app_rounded),
            title: Text('Salir'),
            onTap: () {
              Navigator.pop(context);
            },
          ),  
          ListTile(
            title: const Text("Etiquetas disponibles:"),
            subtitle: Tags(  
              direction: Axis.horizontal,
              itemCount: tagsList.length, 
              itemBuilder: (int index){ 
              return Tooltip(
                message: tagsList[index].nombre,
                child: ItemTags(
                  textStyle: const TextStyle(fontSize: 20),
                  textActiveColor: Colors.black,
                  color:  Colors.blueGrey,
                  activeColor: Colors.white,
                  title: tagsList[index].nombre, index: index,
                  pressEnabled: true,
                  onPressed: (item) {
                    if (item.active! == false){
                      selectedTags.add(tagsList[index]);
                    }else{
                      selectedTags.removeWhere((element) => tagsList[index].id == element.id);
                    }
                  },
               )   
             );
            } 
          )
         ) 
       ],
      );
}

}