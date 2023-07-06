// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:firstapp/infrastructure/views/noteWidgets/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:file_picker/file_picker.dart';

import 'package:html/parser.dart' show parse;

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
  String result = '';
  final HtmlEditorController editorC = HtmlEditorController();
  bool loading = false;
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
                //initialText: html,
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

 void guardarStrong() async {
  String myString = await editorC.getText();

   int sizeInBytes = myString.codeUnits.length * 2;
   print('El tamaño del string es: $sizeInBytes bytes');

      var document = parse(myString);
       var imgElement = document.getElementsByTagName('img').firstWhere((element) =>
        element.attributes.containsKey('src') && element.attributes['src']!.startsWith('data:image/'));
      
       String base64Image = imgElement.attributes['src']!;

       Uint8List decodedImage = base64.decode(base64Image.split(',')[1]);

   print(decodedImage);
   setState(() {

   });
 }

Widget menuOpciones() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            title: Text('Esta seguro que desea eliminar la nota?'),
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('salir'),
            onTap: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (context) => Home()),(Route<dynamic> route) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app_rounded),
            title: Text('Cancelar'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
  }

}

