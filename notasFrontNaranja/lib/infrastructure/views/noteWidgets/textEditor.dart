// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:firstapp/controllerFactory.dart';
import 'package:firstapp/infrastructure/controllers/notaNuevaWidgetController.dart';
import 'package:firstapp/infrastructure/implementations/imagePickerGalleryImp.dart';
import 'package:firstapp/infrastructure/implementations/imagePickerImp.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/home.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/map.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/speech_to_text_prueba.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:file_picker/file_picker.dart';
import '../../../domain/etiqueta.dart';
import '../../../domain/folder.dart';
import '../../../domain/location.dart';
import '../systemWidgets/widgets.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/drawing_room_screen.dart';
import 'package:path_provider/path_provider.dart';

import '../../../domain/tarea.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/notaTareas.dart';
// Ventana para crear una nueva nota
class HtmlEditorExampleApp extends StatelessWidget {
  HtmlEditorExampleApp({super.key});

  HtmlEditorExample textEditor = HtmlEditorExample();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nueva nota"),
        backgroundColor: const Color.fromARGB(255, 30, 103, 240),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
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
  HtmlEditorExampleState createState() => HtmlEditorExampleState();
}

class HtmlEditorExampleState extends State<HtmlEditorExample> {
  String initialText = '';
  bool loading = false;

  final notaNuevaWidgetController controller =
      controllerFactory.notaNuevaWidController();

  final HtmlEditorController editorC = HtmlEditorController();
  final TextEditingController tituloC = TextEditingController();

  List<etiqueta> tagsList = [];
  List<etiqueta> selectedTags = [];
  List<folder> folders = [];
  List<tarea> tasks = [];
  folder? selectedFolder;
  location? noteLocation;

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
    if (controllerResponse.isLeft) {
      showSystemMessage(controllerResponse.left.message);
    } else {
      tagsList = controllerResponse.right;
    }
    /////
    var getFoldersRes = await controller.getAllFolders();
    if (getFoldersRes.isLeft) {
      showSystemMessage(getFoldersRes.left.message);
    }
    setState(() {
      loading = false;
    });
    folders = getFoldersRes.right;
  }

  @override
  Widget build(BuildContext context) {
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
                ]
                        // )
                        )));
  }

// Cuerpo de la nota (Editor de texto)
 Widget htmlEditor(){
  return HtmlEditor(
                controller: editorC, //required
                htmlEditorOptions: HtmlEditorOptions(
                initialText: initialText,
                hint: 'Escriba aqui...'        
              ),
              htmlToolbarOptions: HtmlToolbarOptions(
              toolbarPosition: ToolbarPosition.belowEditor, //by default
              toolbarType: ToolbarType.nativeScrollable, // .nativeGrid,
              renderBorder: false,
              customToolbarButtons: [ 
                // Boton para las opciones extra en la nota (voz a texto, esbozar, imagen a texto)
                ElevatedButton(onPressed: () {
                 showBottomSheet(context: context, builder: (context) => menuOpciones());
                }, 
                child: const Icon(Icons.add)
                )             
              ],
              mediaUploadInterceptor: fileInterceptor
              ), //
              otherOptions: OtherOptions(
              height: 550,
              decoration: BoxDecoration()
              ),
            );
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


// Envia a la ventana principal luego de guardar la nueva nota
  void regresarHome() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()),
        (Route<dynamic> route) => false);
  }

// Funcion para guardar una nota
  void saveNota() async {
    if(tituloC.text != ""){
    String? folderId;
    String text = await editorC.getText();
    if (selectedFolder != null) {
      folderId = selectedFolder!.id;
    }
    var controllerResponse = await controller.saveNota(
        titulo: tituloC.text,
        contenido: text,
        etiquetas: selectedTags,
        folderId: folderId,
        latitud: noteLocation != null ? noteLocation!.latitude! : 0,
        longitud: noteLocation != null ? noteLocation!.longitude! : 0, tareas: tasks);
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

// Funcion para insertar la imagen a texto en el cuerpo de la nota
  void imageToText() async {
    var controllerResponse = await controller.showTextFromIA();
    if (controllerResponse.isLeft) {
      showSystemMessage(controllerResponse.left.message);
    } else {
      String text = controllerResponse.right;
      editorC.setText(await editorC.getText() + text);
    }
  }

// Funcion para insertar el voice to text en el cuerpo de la nota
  void voiceToText() async {
    String espacio = " ";
    String audio = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => SpeechScreen(text: '')));
    editorC.setText(await editorC.getText() + espacio + audio + espacio);
  }

// Funcion para insertar el esbozado en el cuerpo de la nota
  void esbozado(PlatformFile file) async {
    String base64Data = base64.encode(file.bytes!);
    String base64Image =
        """<img src="data:image/${file.extension};base64,$base64Data" data-filename="${file.name}" width="300" height="300"/>""";
    editorC.insertHtml(base64Image);
  }

  void showSystemMessage(String? message) {
    setState(() {
      loading = false;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message!)));
  }

  void accesoGeolocalizacion() async{
    var usuario = await controller.getSuscripcionUsuario();
    
    if (usuario.isRight) {

      if (usuario.right.isSuscribed) {
        Navigator.pop(context);
            noteLocation = await Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => MyMapScreen())); 
      }else{
        ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("No posee suscripcion")));
      }
    }
  }

    void accesoVozATexto() async{
    var usuario = await controller.getSuscripcionUsuario();
    
    if (usuario.isRight) {

      if (usuario.right.isSuscribed) {
        Navigator.pop(context);
        voiceToText();
      }else{
        ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("No posee suscripcion")));
      }
    }
  }

//
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Widget menuOpciones() {
    return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.save),
            title: Text('Guardar nota'),
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
            title: Text('Etiquetas'),
            onTap: () async {
              Navigator.pop(context);
              selectedTags = [];
              showBottomSheet(context: context, builder: (context) => menuEtiquetas());
            },
          ),
          ListTile(
            leading: Icon(Icons.folder_copy_sharp),
            title: Text('Carpeta'),
            onTap: () async {
              Navigator.pop(context);
              showBottomSheet(context: context, builder: (context) => folderList());
            },
          ),
      // Lista de tareas
          ListTile(
            leading: Icon(Icons.add_task),
            title: Text('Tareas'),
            onTap: () async {
              Navigator.pop(context);
              showBottomSheet(context: context, builder: (context) => NotaTareas(tasks: tasks, home: this,));
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: Text('Agregar ubicación'),
            onTap: ()  async {
              accesoGeolocalizacion();
            },
          ),
          ListTile(
            leading: const Icon(Icons.record_voice_over_rounded),
            title: Text('Voz a texto'),
            onTap: () {
              accesoVozATexto();
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
          leading: const Icon(Icons.camera_alt_rounded),
          title: Text('Tomar foto'),
          onTap: () {
            Navigator.pop(context);
            pickImageFromGallery();
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

Widget folderList(){
    return 
        ListView.builder(
          itemCount: folders.length,
          itemBuilder: (context, index) {
            return ListTile(
                      title: 
                      (selectedFolder != null)  
                      ?
                      (selectedFolder!.id == folders[index].id ) ? Text('${folders[index].name} (Seleccionada)') : Text(folders[index].name) 
                      : 
                       Text(folders[index].name) 
                      ,
                      leading: const Icon(Icons.folder),
                      onTap: () {
                        selectedFolder = folders[index];
                        Navigator.pop(context);
                      },
                      );
                   }        
              
          ); 
    }

void pickImageFromGallery() async {
  var fileRes = await imagePickerImp().getImage();
    if (fileRes.isLeft){
     showSystemMessage(fileRes.left.message);
    }
                File file = fileRes.right;
                PlatformFile file2 = await compressFile2(file);
                String base64Data = base64.encode(file2.bytes!);
                String base64Image =
                """<img src="data:image/${file2.extension};base64,$base64Data" data-filename="${file2.name}" width="300" height="300"/>""";
                editorC.insertHtml(base64Image);
    editorC.insertHtml('<br>');        
 } 

 Future<PlatformFile> compressFile2(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.path,
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
