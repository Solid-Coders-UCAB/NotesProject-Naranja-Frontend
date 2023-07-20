// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:firstapp/controllerFactory.dart';
import 'package:firstapp/infrastructure/controllers/editarNotaWidgetController.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/home.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/speech_to_text_prueba.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../../domain/etiqueta.dart';
import '../../../domain/folder.dart';
import '../../../domain/nota.dart';
import '../../../domain/tarea.dart';
import '../systemWidgets/widgets.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/drawing_room_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/notaTareasEditar.dart';
// ignore: must_be_immutable
class HtmlEditorEditar extends StatelessWidget {
  Nota nota;

  HtmlEditorEditar({super.key, required this.nota});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar nota"),
        backgroundColor: const Color.fromARGB(255, 30, 103, 240),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: HtmlEditorExample(nota: nota),
    );
  }
}

// ignore: must_be_immutable
class HtmlEditorExample extends StatefulWidget {
  Nota nota;

  HtmlEditorExample({super.key, required this.nota});

  @override
  HtmlEditorEditExampleState createState() =>
      HtmlEditorEditExampleState(nota: nota);
}

class HtmlEditorEditExampleState extends State<HtmlEditorExample> {
  Nota nota;
  bool loading = false;

  final editarNotaWidgetController controller =
      controllerFactory.editarNotaWidController();

  final HtmlEditorController editorC = HtmlEditorController();
  final TextEditingController tituloC = TextEditingController();

  List<etiqueta> tagsList = [];
  List<etiqueta> selectedTags = [];
  List<etiqueta> oldTags = [];
  List<tarea> tasks = [];
  List<folder> folders = [];
  folder? selectedFolder;

  HtmlEditorEditExampleState({required this.nota});

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
      tasks = nota.tareas;
    });
    init();
  }

  void init() async {
    var controllerResponse = await controller.getAllEtiquetas();
    if (controllerResponse.isRight){
         tagsList = controllerResponse.right;
        if (nota.etiquetas != null){ 
         if (nota.etiquetas!.isNotEmpty){
         for (var tag in nota.etiquetas!) {
          selectedTags.add(tagsList.firstWhere((element) => element.id == tag.id));
         } 
         }
        }
    }
    //
    var folderRes = await controller.getAllFolders();
    if (folderRes.isRight) {
      folders = folderRes.right;
      selectedFolder =
          folders.firstWhere((element) => element.id == nota.idCarpeta);
    }
    
    setState(() {loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    tituloC.text = nota.titulo;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        color: Colors.white,
        child: loading == true
            ? const Center(
                child: SizedBox(
                    width: 30, height: 30, child: CircularProgressIndicator()))
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child:
                    //  Form(
                    //    child:
                    Column(children: [
                  genericTextFormField(tituloC, "Título de la nota", false, 40),
                  htmlEditor()
                ])
                // )
                ));
  }

 Widget htmlEditor(){
  return HtmlEditor(
                controller: editorC, //required
                htmlEditorOptions: HtmlEditorOptions(
                initialText: nota.contenido,
                hint: 'Recuperando contenido...'      
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
                file = await CompressFile(file);
                String base64Data = base64.encode(file.bytes!);
                String base64Image =
                """<img src="data:image/${file.extension};base64,$base64Data" data-filename="${file.name}" width="300" height="300"/>""";
                editorC.insertHtml(base64Image);
              }
    editorC.insertHtml('<br>');         
   return false; 
 }

  void regresarHome() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()),
        (Route<dynamic> route) => false);
  }

  void editarNota() async {
    if(tituloC.text != ""){
    String text = await editorC.getText();
    setState(() {
      loading = true;
    });
    var controllerResponse = await controller.updateNota(
        titulo: tituloC.text,
        contenido: text,
        idCarpeta:
            (selectedFolder == null) ? nota.idCarpeta : selectedFolder!.id!,
        idNota: nota.id,
        n_date: nota.n_date,
        etiquetas: selectedTags, tareas: tasks);

    if (controllerResponse.isLeft) {
      showSystemMessage(controllerResponse.left.message);
    } else {
      showSystemMessage('Nota guardada satisfactoriamente');
      regresarHome();
    }
    } else{
      showSystemMessage('El titulo de la nota no debe estar vacio');
    }
  }

  void eliminarNota() async {
    String text = await editorC.getText();
    controller.eliminarNotaAction1(
        widget: this,
        titulo: tituloC.text,
        contenido: text,
        idCarpeta:
            (selectedFolder == null) ? nota.idCarpeta : selectedFolder!.id!,
        id: nota.id,
        n_date: nota.n_date,
        etiquetas: selectedTags, tareas: tasks);
  }

  void imageToText() async {
    var controllerResponse = await controller.showTextFromIA();
    String text = controllerResponse.right;
    if (controllerResponse.isLeft) {
      showSystemMessage(controllerResponse.left.message);
    } else {
      editorC.setText(await editorC.getText() + text);
    }
  }

  void voiceToText() async {
    String espacio = " ";
    String audio = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => SpeechScreen(text: '')));
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

  void showSystemMessage(String? message) {
    setState(() {
      loading = false;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message!)));
  }

  Widget menuOpciones() {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
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
          leading: Icon(Icons.delete_rounded),
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
          leading: const Icon(Icons.new_label_rounded),
          title: Text('Etiquetas'),
          onTap: () {
            Navigator.pop(context);
            selectedTags = [];
            showBottomSheet(
                context: context, builder: (context) => menuEtiquetas());
          },
        ),
        ListTile(
          leading: Icon(Icons.folder_copy_sharp),
          title: Text('Carpeta'),
          onTap: () async {
            Navigator.pop(context);
            showBottomSheet(
                context: context, builder: (context) => folderList());
          },
        ),
              // Lista de tareas
          ListTile(
            leading: Icon(Icons.add_task),
            title: Text('Tareas'),
            onTap: () async {
              Navigator.pop(context);
              showBottomSheet(context: context, builder: (context) => NotaTareasEditar(tasks: tasks, home: this,));
            },
          ),
        ListTile(
          leading: const Icon(Icons.map),
          title: Text('Agregar ubicación'),
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
          onTap: () async {
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
                itemBuilder: (int index) {
                  return Tooltip(
                      message: tagsList[index].nombre,
                      child: ItemTags(
                        textStyle: const TextStyle(fontSize: 20),
                        textActiveColor: Colors.black,
                        color: Colors.blueGrey,
                        activeColor: Colors.white,
                        title: tagsList[index].nombre,
                        index: index,
                        pressEnabled: true,
                        onPressed: (item) {
                          if (item.active! == false) {
                            selectedTags.add(tagsList[index]);
                          } else {
                            selectedTags.removeWhere(
                                (element) => tagsList[index].id == element.id);
                          }
                        },
                      ));
                }))
      ],
    );
  }

  Widget folderList() {
    return ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: (selectedFolder != null)
                ? (selectedFolder!.id == folders[index].id)
                    ? Text('${folders[index].name} (seleccionada)')
                    : Text(folders[index].name)
                : Text(folders[index].name),
            leading: const Icon(Icons.folder),
            onTap: () {
              selectedFolder = folders[index];
              Navigator.pop(context);
            },
          );
        });
  }


Future<PlatformFile> CompressFile(PlatformFile file) async {
      var result = await FlutterImageCompress.compressWithFile(
      file.path!,
      minWidth: 300,
      minHeight: 300,
      quality: 100,
      //rotate: 90,
    );
    final appStorage = await _localPath;
                  int randomNumber = Random().nextInt(10000);
                  String imageName = 'image$randomNumber';
                  final archivo = File('$appStorage/$imageName.png');
                  archivo.writeAsBytes(result!.cast<int>()); 

                  PlatformFile newFile = PlatformFile(
                    name: imageName,
                    bytes: result,
                    path: archivo.path, 
                    size: 0,
                  );
    return newFile;
  }


}
