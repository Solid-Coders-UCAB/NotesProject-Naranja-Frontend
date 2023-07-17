import 'dart:io';
import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/application/DTOS/createNoteParams.dart';
import 'package:firstapp/application/DTOS/imageToTextParams.dart';
import 'package:firstapp/domain/location.dart';

import '../../domain/etiqueta.dart';
import '../../domain/folder.dart';

class notaNuevaWidgetController {
  service<imageToTextParams, String> imageToText;
  service<void, File> imageService;
  service<void, File> galleryService;
  service<CreatenoteParams, String> createNotaService;
  service<void, Location> locationService;
  service<void,List<etiqueta>> getAllEtiquetasService;
  service<void,List<folder>> getAllFoldersService;

  notaNuevaWidgetController(
      {required this.imageToText,
      required this.imageService,
      required this.galleryService,
      required this.createNotaService,
      required this.locationService,
      required this.getAllEtiquetasService,
      required this.getAllFoldersService});

  Future<Either<MyError, String>> saveNota(
      {required String titulo,
      required String contenido,
      String? folderId,
      int? longitud,
      int? latitud,
      List<etiqueta>? etiquetas,
      List<Uint8List>? imagenes}) async {
    
    longitud ??= 0;
    latitud ??= 0;
    etiquetas ??= [];

    var params = CreatenoteParams(
        titulo: titulo,
        contenido: contenido,
        imagenes: imagenes,
        longitud: longitud,
        latitud: latitud,
        folderId: folderId,
        etiquetas: etiquetas);

        print(params.contenido);



    var serviceResponse = await createNotaService.execute(params);

   

    if (serviceResponse.isLeft) {
      return Left(serviceResponse.left);
    }

    return Right(serviceResponse.right);
  }

  Future<Either<MyError, String>> showTextFromIA() async {
    var imageReponse = await imageService.execute(null);

    if (imageReponse.isLeft) {
      return Left(imageReponse.left);
    }

    var iaResponse =
        await imageToText.execute(imageToTextParams(image: imageReponse.right));
    if (iaResponse.isLeft) {
      return Left(iaResponse.left);
    }

    return Right(iaResponse.right);
  }

  Future<Either<MyError, Uint8List>> getImageGallery() async {
    var imageReponse = await galleryService.execute(null);

    if (imageReponse.isLeft) {
      return Left(imageReponse.left);
    }

    Uint8List imagen = imageReponse.right.readAsBytesSync();

    return Right(imagen);
  }

  Future<Either<MyError, Location>> getUserLocation() async {
    var locationResponse = await locationService.execute(null);

    if (locationResponse.isLeft) {
      return Left(locationResponse.left);
    }
    Location location = locationResponse.right;
    return Right(location);
  }

  Future<Either<MyError, List<etiqueta>>> getAllEtiquetas() async {
    var serviceResponse = await getAllEtiquetasService.execute(null); 
      if (serviceResponse.isLeft){
        return Left(serviceResponse.left);        
      }
     return Right(serviceResponse.right); 
  }

  Future<Either<MyError, List<folder>>> getAllFolders() async {
    return await getAllFoldersService.execute(null);
  }

}
