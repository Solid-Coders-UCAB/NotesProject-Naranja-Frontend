// ignore_for_file: file_names, implementation_imports

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:either_dart/src/either.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/domain/repositories/noteRepository.dart';
import 'package:http/http.dart';

class httpNoteRepository implements noteRepository{
  
  @override
  Future<Either<MyError, String>> createNota(Nota note) async {
    var body = jsonEncode({
    "titulo": note.getTitulo,
    "cuerpo": note.getContenido,
    "fechaCreacion": note.getDate.toString(),
    "fechaModificacion": note.getEditDate.toString(),
    "estado": note.getEstado,
    "longitud": note.getLongitud,
    "latitud": note.getLatitud
   });

    Response response;

  try{ 

    response = await post(Uri.parse('http://192.168.1.2:3000/nota/create'), //aqui colocar la red de tu compu local
      body: body,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      });

    // return Right(response.body);  

  }catch(e){
    String error = 'error al procesar la solicitud al servidor: $e';
         return Left(MyError(key: AppError.NotFound,
                                  message: error));
  } 

    return Right(response.body);
 }
 
  @override
  Future<Either<MyError, List<Nota>>> getALLnotes() async {

    List<Nota> notas = [];
    List<Uint8List> images = [];
    int contador = 0;
    var response = await get(Uri.parse('http://192.168.1.13:3000/nota/findAll'));
   
    if (response.statusCode == 200){

      var jsonData = json.decode(response.body);

      for (var jsonNote in jsonData){

       for (var jsonImage in jsonNote['cuerpo']['imagen']){
        contador = contador + 1;
        List<dynamic> bufferDynamic = jsonImage["data"];
        Uint8List buffer = Uint8List.fromList(bufferDynamic.cast<int>());
        images.add(buffer);
       }

       Nota nota =  Nota.create( id: jsonNote['id']['UUID'],
                     titulo: jsonNote['titulo']['titulo'],
                     contenido: jsonNote['cuerpo']['cuerpo'],
                     n_edit_date: DateTime.tryParse(jsonNote['fechaModificacion']['fecha']),
                     n_date: DateTime.tryParse(jsonNote['fechaCreacion']['fecha']) ,
                     estado: jsonNote['estado'],
                     latitud: jsonNote['geolocalizacion']['latitud'],
                     longitud: jsonNote['geolocalizacion']['longitud'],
                     imagenes: images                                
               ).right;

        notas.add(nota);
        images = [];
      } 


      return Right(notas);
    }
          
    return Left(MyError(key: AppError.NotFound,
                message: response.body ));
                
}
    
}