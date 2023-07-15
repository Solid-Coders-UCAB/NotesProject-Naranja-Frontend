// ignore_for_file: file_names, implementation_imports
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:either_dart/either.dart';
import 'package:path_provider/path_provider.dart';
import 'package:either_dart/src/either.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/domain/repositories/noteRepository.dart';
import 'package:http/http.dart';

class httpNoteRepository implements noteRepository{

  String domain = '192.168.1.2:3000';

  
  @override
  Future<Either<MyError, String>> createNota(Nota note) async {

    var body = jsonEncode({
      "titulo": note.getTitulo,
      'cuerpo':note.getContenido,
      'estado':note.getEstado,
      'fechaModificacion': note.getEditDate.toString(),
      'fechaCreacion': note.getDate.toString(),
      'idCarpeta': note.idCarpeta
    });

  try{

  final Response response = await post(Uri.parse('http://$domain/nota/create'),
      body: body,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      });
  
      if (response.statusCode == 200){
        return const Right('nota guardada exitosamente');
      }else{
        return Left(MyError(key: AppError.NotFound,message: response.body));
      }

  }catch(e){
      return Left(MyError(key: AppError.NotFound,message: '$e'));
  }                   

 }

 
  @override
  Future<Either<MyError, List<Nota>>> getALLnotes(String userId) async {

    List<Nota> notas = [];
    Response response;
    var body = jsonEncode({
      'idUsuario': userId
    });


    try{ 
     response = await post(Uri.parse('http://$domain/nota/findByUser'),
      body: body,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      });
    }catch(e){
      return Left(MyError(key: AppError.NotFound,
                                  message: "$e"));
    }

   if (response.statusCode == 200){

      var jsonData = json.decode(response.body);

      for (var jsonNote in jsonData){

      /* for (var jsonImage in jsonNote['cuerpo']['imagen']){
        List<dynamic> bufferDynamic = jsonImage["data"];
        Uint8List buffer = Uint8List.fromList(bufferDynamic.cast<int>());
        images.add(buffer);
       }
      */ 

       Nota nota =  Nota.create( id: jsonNote['id']['UUID'],
                     titulo: jsonNote['titulo']['titulo'],
                     contenido: jsonNote['cuerpo']['cuerpo'],
                     n_edit_date: DateTime.tryParse(jsonNote['fechaModificacion']['fecha']),
                     n_date: DateTime.tryParse(jsonNote['fechaCreacion']['fecha']) ,
                     estado: jsonNote['estado'], 
                     carpeta: ''                            
               ).right;

        var jsonAssignedGeolocalitation = jsonNote['geolocalizacion']['assigned'];
        if ( jsonAssignedGeolocalitation){
            nota.latitud = jsonNote['geolocalizacion']['latitud'];
            nota.longitud = jsonNote['geolocalizacion']['longitud'];
        }else{
            nota.latitud = null;
            nota.longitud = null;
        }


        notas.add(nota);
        //images = [];
      } 
      return Right(notas);
    }
          
    return Left(MyError(key: AppError.NotFound,
                message: response.body ));
                
}

@override
Future<Either<MyError, String>> updateNota(Nota note) async {
    var body = jsonEncode({
      "idNota": note.id,
      "titulo": note.getTitulo,
      'cuerpo':note.getContenido,
      'estado':note.getEstado,
      'fechaModificacion': note.getEditDate.toString(),
      'fechaCreacion': note.getDate.toString(),
      'idCarpeta': note.idCarpeta,
      'latitud': note.latitud,
      'longitud': note.longitud
    });
  try{
  final Response response = await put(Uri.parse('http://$domain/nota/modificate'),
      body: body,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      });
      if (response.statusCode == 200){
        return const Right('Nota actualizada exitosamente');
      }else{
        return Left(MyError(key: AppError.NotFound,message: response.body));
      }
  }catch(e){
      return Left(MyError(key: AppError.NotFound,message: '$e'));
  } 
 }
 
@override
Future<Either<MyError, String>> deleteNota(Nota note) async {    
     var body = jsonEncode({
        "idNota": note.id,
      });
  Response r1;
  try{
   r1 = await post(Uri.parse('http://$domain/nota/delete'),
      body: body,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      });
  }catch(e){
    return Left(MyError(key: AppError.NotFound,
                                  message: "$e"));
  }
    if (r1.statusCode != 200){
      return Left(MyError(key: AppError.NotFound,
                                  message: r1.body));
    }
  return const Right('nota eliminada exitosamente');     
}

}


void main() async {
  var execute = await httpNoteRepository().getALLnotes('');
    if (execute.isLeft){
      print(execute.left.message);
    }else{
      print(execute.right.first.contenido);
    }
    
}