// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:firstapp/controllerFactory.dart';
import 'package:firstapp/infrastructure/controllers/notaNuevaWidgetController.dart';
import 'package:firstapp/infrastructure/views/etiquetasWidgets/notaEtiquetas.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/home.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/speech_to_text_prueba.dart';

import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:file_picker/file_picker.dart';
import '../systemWidgets/widgets.dart';


class HtmlEditorExampleApp extends StatelessWidget {
  
  HtmlEditorExampleApp({super.key});

  HtmlEditorExample textEditor = HtmlEditorExample();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nueva nota"),
        backgroundColor: const Color.fromARGB(255, 99, 91, 250),
        leading: IconButton(
            icon: Icon(Icons.transit_enterexit_outlined),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: textEditor,
    );
  }

} 

class HtmlEditorExample extends StatefulWidget {
  
  const HtmlEditorExample({super.key});

  @override
  _HtmlEditorExampleState createState() => _HtmlEditorExampleState();
}

class _HtmlEditorExampleState extends State<HtmlEditorExample> {  
  String initialText = '';
  bool loading = false;

  final notaNuevaWidgetController controller = controllerFactory.notaNuevaWidController();

  final HtmlEditorController editorC = HtmlEditorController();
  final TextEditingController tituloC = TextEditingController();



  @override
  Widget build(BuildContext context) {
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
        Form(
          child:
          Column( 
            children: [
              genericTextFormField(tituloC, "Título de la nota", false, 40),
              htmlEditor()
          ]       
      )
    )
   )
  );
 }

 Widget htmlEditor(){
  return HtmlEditor(
                controller: editorC, //required
                htmlEditorOptions: HtmlEditorOptions(
                initialText: initialText,
                hint: 'escribe aqui'        
              ),
              htmlToolbarOptions: HtmlToolbarOptions(
              toolbarPosition: ToolbarPosition.belowEditor, //by default
              toolbarType: ToolbarType.nativeGrid,
              renderBorder: false,
              customToolbarButtons: [
                ElevatedButton(onPressed: () {
                 showBottomSheet(context: context, builder: (context) => menuOpciones());
                }, child: const Text('mas opciones'))             
              ],
              mediaUploadInterceptor: fileInterceptor
              ), //
              otherOptions: OtherOptions(
              height: 600,
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

void saveNota() async {
  
  String text = await editorC.getText();
  var controllerResponse = await controller.saveNota(titulo: tituloC.text, contenido: text);  
  if (controllerResponse.isLeft){
    showSystemMessage(controllerResponse.left.message);
  }else{
     showSystemMessage('nota guardada satisfactoriamente');
     regresarHome();
  }
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
            title: Text('guardar nota'),
            onTap: () async {
              Navigator.pop(context);     
              saveNota();    
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
            leading: Icon(Icons.new_label),
            title: Text('etiquetas'),
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => notaEtiquetas()));
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
            title: Text('Agregar dibujo'),
            onTap: () {
              Navigator.pop(context);
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

}

