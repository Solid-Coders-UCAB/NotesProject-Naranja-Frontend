// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:file_picker/file_picker.dart';

import 'package:html/parser.dart' show parse;


void main() => runApp(HtmlEditorExampleApp());

class HtmlEditorExampleApp extends StatelessWidget {
  const HtmlEditorExampleApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      home: HtmlEditorExample(title: 'Flutter HTML Editor Example'),
    );
  }
}

class HtmlEditorExample extends StatefulWidget {
  
  const HtmlEditorExample({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HtmlEditorExampleState createState() => _HtmlEditorExampleState();
}

class _HtmlEditorExampleState extends State<HtmlEditorExample> {
  
  String result = '';
  final HtmlEditorController controller = HtmlEditorController();


  @override
  Widget build(BuildContext context) {
    return  
    Scaffold(
    appBar: AppBar(), 
    body:  
    SingleChildScrollView(
      scrollDirection: Axis.vertical,
    child:
    HtmlEditor(
        controller: controller, //required
        htmlEditorOptions: HtmlEditorOptions(
          //initialText: html,
          hint: 'escribe aqui'        
        ),
        htmlToolbarOptions: HtmlToolbarOptions(
        toolbarPosition: ToolbarPosition.aboveEditor, //by default
        toolbarType: ToolbarType.nativeScrollable,
        renderBorder: false,
        mediaUploadInterceptor:
                      (PlatformFile file, InsertFileType type) async {
                    
            if (type == InsertFileType.image) {
              String base64Data = base64.encode(file.bytes!);
              String base64Image =
              """<img src="data:image/${file.extension};base64,$base64Data" data-filename="${file.name}" width="300" height="300"/>""";
              controller.insertHtml(base64Image);
            }
                return false;    
                     }

         ), //
        otherOptions: OtherOptions(
        height: 800,
        decoration: BoxDecoration()
        ),
        ),       
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async => {
        guardarStrong()
      }),  
    );
 }

 void guardarStrong() async {
  String myString = await controller.getText();

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

}