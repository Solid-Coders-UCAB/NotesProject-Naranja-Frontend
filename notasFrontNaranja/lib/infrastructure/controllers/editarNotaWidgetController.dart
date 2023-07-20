// ignore_for_file: invalid_use_of_protected_member

import 'dart:io';
import 'dart:typed_data';
import 'package:either_dart/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/application/DTOS/imageToTextParams.dart';
import 'package:firstapp/application/DTOS/updateNoteParams.dart';
import '../../domain/etiqueta.dart';
import '../../domain/folder.dart';
import '../../domain/tarea.dart';
import '../views/noteWidgets/editarNotaEditor.dart'; 
import 'package:firstapp/domain/user.dart';

class editarNotaWidgetController {

  service<imageToTextParams,String> imageToText;
  service<void,File> imageService;
  service<void,File> galleryService;
  service<UpdateNoteParams,String> updateNotaService;
  service<void,List<etiqueta>> getAllEtiquetasService;
  service<void,List<folder>> getAllFoldersService;
  service<void, user> getUserByIdService;

  editarNotaWidgetController(
    {required this.imageToText, 
    required this.imageService, required this.galleryService, 
    required this.updateNotaService, required this.getAllEtiquetasService,
    required this.getAllFoldersService,
    required this.getUserByIdService });

  Future<Either<MyError,String>> updateNota(
    {required String titulo, 
     required String contenido,int? longitud,int? latitud, List<Uint8List>? imagenes, 
     required String idNota, required DateTime n_date, required String idCarpeta, List<etiqueta>? etiquetas, required List<tarea> tareas} ) async {
    longitud??=0;
    latitud??=0;

    var serviceResponse = await updateNotaService.execute(UpdateNoteParams(
      estado: 'Guardada',
      idNota: idNota, 
      titulo: titulo, 
      contenido: contenido,
      imagenes: imagenes,
      longitud: longitud,
      latitud: latitud, 
      n_date: n_date,
      etiquetas: etiquetas,
      idCarpeta: idCarpeta,
      tareas: tareas));

      if (serviceResponse.isLeft){
        return Left(serviceResponse.left);
      }

      return Right(serviceResponse.right);
  }
   
   Future<Either<MyError,String>> showTextFromIA () async {

    var imageReponse = await imageService.execute(null);

      if (imageReponse.isLeft){
          return Left(imageReponse.left);
      }

      
    var iaResponse = await imageToText.execute(imageToTextParams(image: imageReponse.right));
        if (iaResponse.isLeft){
          return Left(iaResponse.left);
        }
    
    return Right(iaResponse.right);
   }

   Future<Either<MyError,Uint8List>> getImageGallery () async {

    var imageReponse = await galleryService.execute(null);

      if (imageReponse.isLeft){
          return Left(imageReponse.left);
      }

      Uint8List imagen = imageReponse.right.readAsBytesSync();
    
    return Right(imagen);
   }

  void eliminarNotaAction1({ required HtmlEditorEditExampleState widget, required String id,
    required String titulo, 
    required String contenido,int? longitud,
    int? latitud, List<Uint8List>? imagenes,required n_date,
    required String idCarpeta, List<etiqueta>? etiquetas, required List<tarea> tareas }) async {
      
     widget.setState(() {
       widget.loading = true;
     }); 

    var serviceResponse = await updateNotaService.execute(UpdateNoteParams(
      estado: 'Eliminada',
      idNota: id,
      titulo: titulo, 
      contenido: contenido,
      imagenes: imagenes,
      longitud: longitud,
      latitud: latitud, 
      n_date: n_date,
      etiquetas: etiquetas,
      idCarpeta: idCarpeta,
      tareas: tareas));

      if (serviceResponse.isLeft){
       widget.setState(() {
         widget.loading = false;
       });
       widget.showSystemMessage(serviceResponse.left.message); 
      }else{
       widget.showSystemMessage("nota eliminada satisfactoriamente");
       widget.regresarHome();
      }      
   }

  Future<Either<MyError, List<etiqueta>>> getAllEtiquetas() async {
    return await getAllEtiquetasService.execute(null); 
  }

  Future<Either<MyError, List<folder>>> getAllFolders() async {
    return await getAllFoldersService.execute(null);
  }

  Future<Either<MyError, user>> getSuscripcionUsuario() async {
    var serviceResponse = await getUserByIdService.execute(null);
    return serviceResponse;
  }
}