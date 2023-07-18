// ignore_for_file: file_names, implementation_imports
import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:either_dart/src/either.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/domain/repositories/noteRepository.dart';
import 'package:firstapp/infrastructure/implementations/repositories/HTTPrepository.dart';
import 'package:http/http.dart';

import '../../../domain/etiqueta.dart';

class httpNoteRepository extends HTTPrepository implements noteRepository{
  
  @override
  Future<Either<MyError, String>> createNota(Nota note) async {

    print(note.latitud);

    var body = jsonEncode({
      "titulo": note.getTitulo,
      'cuerpo':note.getContenido,
      'estado':note.getEstado,
      'fechaModificacion': note.getEditDate.toString(),
      'fechaCreacion': note.getDate.toString(),
      'idCarpeta': note.idCarpeta,
      'etiquetas': note.getEtiquetasIds(),
      "latitud":  note.latitud,
      "longitud": note.longitud
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
    List<etiqueta> etiquetas = [];
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

          for (var eti in jsonNote['etiquetas']) {
            etiquetas.add( etiqueta(nombre: '', idUsuario: '',id: eti['id']) );
          }
       
       Nota nota =  Nota.create( id: jsonNote['id']['UUID'],
                     titulo: jsonNote['titulo']['titulo'],
                     contenido: jsonNote['cuerpo']['cuerpo'],
                     n_edit_date: DateTime.tryParse(jsonNote['fechaModificacion']['fecha']),
                     n_date: DateTime.tryParse(jsonNote['fechaCreacion']['fecha']) ,
                     estado: jsonNote['estado'], 
                     carpeta: jsonNote['idCarpeta']['UUID'],
                     etiquetas: etiquetas                            
               ).right;

        var jsonAssignedGeolocalitation = jsonNote['geolocalizacion']['assigned'];
        print("assigned:${jsonAssignedGeolocalitation}");
        if ( jsonAssignedGeolocalitation){
            nota.latitud = double.parse( jsonNote['geolocalizacion']['value']['latitud'].toString());
            nota.longitud = double.parse(jsonNote['geolocalizacion']['value']['longitud'].toString());
        }else{
            nota.latitud = null;
            nota.longitud = null;
        }
        notas.add(nota);
        etiquetas = [];
      } 
      return Right(notas);
    }
          
    return Left(MyError(key: AppError.NotFound,
                message: response.body ));
                
}

 Future<Either<MyError, List<Nota>>> getALLnotesPreview(String userId) async {

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

       Nota nota =  Nota.create( id: jsonNote['id']['UUID'],
                     titulo: jsonNote['titulo']['titulo'],
                     n_edit_date: DateTime.tryParse(jsonNote['fechaModificacion']['fecha']),
                     n_date: DateTime.tryParse(jsonNote['fechaCreacion']['fecha']) ,
                     estado: jsonNote['estado'], 
                     carpeta: jsonNote['idCarpeta']['UUID'],                    
               ).right;

        var jsonAssignedGeolocalitation = jsonNote['geolocalizacion']['assigned'];
        print("assigned:${jsonAssignedGeolocalitation}");
        if ( jsonAssignedGeolocalitation){
            nota.latitud = double.parse( jsonNote['geolocalizacion']['value']['latitud'].toString());
            nota.longitud = double.parse(jsonNote['geolocalizacion']['value']['longitud'].toString());
        }else{
            nota.latitud = null;
            nota.longitud = null;
        }
        notas.add(nota);
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
      'longitud': note.longitud,
      'etiquetas': note.getEtiquetasIds()
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
   r1 = await delete(Uri.parse('http://$domain/nota/delete'),
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

  @override
  Future<Either<MyError, List<Nota>>> getAllEliminatedNotes(String userId) async {
    List<Nota> notas = [];
    Response response;
    var body = jsonEncode({
      'idUsuario': userId
    });
    try{ 
     response = await post(Uri.parse('http://$domain/nota/findDeleted'),
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
       Nota nota =  Nota.create( id: jsonNote['id']['UUID'],
                     titulo: jsonNote['titulo']['titulo'],
                     contenido: jsonNote['cuerpo']['cuerpo'],
                     n_edit_date: DateTime.tryParse(jsonNote['fechaModificacion']['fecha']),
                     n_date: DateTime.tryParse(jsonNote['fechaCreacion']['fecha']) ,
                     estado: jsonNote['estado'], 
                     carpeta: jsonNote['idCarpeta']['UUID']                            
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
      } 
      return Right(notas);
    }
          
    return Left(MyError(key: AppError.NotFound,
                message: response.body ));
  }

  @override
Future<Either<MyError, List<Nota>>> getNotesByKeyword(String palabraClave, String idUsuario) async {

    List<Nota> notas = [];
    List<etiqueta> etiquetas = [];
    Response response;
    var body = jsonEncode({
      "palabraClave": palabraClave,
      "idUsuario": idUsuario
    });


    try{ 
     response = await post(Uri.parse('http://$domain/nota/findByKeyword'),
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

          for (var eti in jsonNote['etiquetas']) {
            etiquetas.add( etiqueta(nombre: '', idUsuario: '',id: eti['id']) );
          }
       
       Nota nota =  Nota.create( id: jsonNote['id']['UUID'],
                     titulo: jsonNote['titulo']['titulo'],
                     contenido: jsonNote['cuerpo']['cuerpo'],
                     n_edit_date: DateTime.tryParse(jsonNote['fechaModificacion']['fecha']),
                     n_date: DateTime.tryParse(jsonNote['fechaCreacion']['fecha']) ,
                     estado: jsonNote['estado'], 
                     carpeta: jsonNote['idCarpeta']['UUID'],
                     etiquetas: etiquetas                            
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
        etiquetas = [];
      } 
      return Right(notas);
    }
          
    return Left(MyError(key: AppError.NotFound,
                message: response.body ));
                
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