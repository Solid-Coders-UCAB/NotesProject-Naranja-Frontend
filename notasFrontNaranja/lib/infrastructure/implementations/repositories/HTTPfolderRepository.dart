import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:either_dart/src/either.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/folder.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/domain/etiqueta.dart';
import 'package:firstapp/domain/repositories/folderRepository.dart';
import 'package:firstapp/infrastructure/implementations/repositories/HTTPrepository.dart';
import 'package:http/http.dart';

class HTTPfolderRepository extends HTTPrepository implements folderRepository {

  @override
  Future<Either<MyError, String>> createFolder(folder folder) async {
    
    var body = jsonEncode({
    "nombre": folder.name,
    "predeterminada": false,
    "idUsuario": folder.idUsuario
  });

  try{

  final Response response = await post(Uri.parse('http://$domain/carpeta/create'),

      body: body,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      });

      if (response.statusCode == 200){
        return const Right('Carpeta guardada exitosamente');
      }else{
        return Left(MyError(key: AppError.NotFound,message: response.body));
      }

  }catch(e){
      return Left(MyError(key: AppError.NotFound,message: '$e'));
  }  

  }

  @override
  Future<Either<MyError, List<folder>>> getALLfolders(String userId) async {

  Response response1;
  List<folder> folders = [];
  var body = jsonEncode({
    "idUsuario": userId,
  });

  try{
      response1 = await post(Uri.parse('http://$domain/carpeta/findByUser'),
      body: body,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      });
  }catch(e){
    return Left(MyError(key: AppError.NotFound,message: '$e'));
  }

  if (response1.statusCode == 200){

   var jsonData = json.decode(response1.body);    

    for (var jsonFolder in jsonData){
      var f = folder.create(name: jsonFolder['nombre']['nombre'],
                    id:   jsonFolder['id']['UUID'],
                    predeterminada: jsonFolder['predeterminada'],
                    idUsuario: jsonFolder['idUsuario']['UUID']
                    );

      folders.add(f.right);              
    }

    return Right(folders);

  }else{
   return Left(MyError(key: AppError.NotFound,message: response1.body));
  }

  }
  
    @override
  Future<Either<MyError, String>> updateFolder(folder folder) async {
    
    var body = jsonEncode({
    "nombre": folder.name,
    "idCarpeta": folder.id.toString(),
    "predeterminada": false,
    "idUsuario": folder.idUsuario
  });

  try{

  final Response response = await put(Uri.parse('http://$domain/carpeta/modificate'),

      body: body,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      });

      if (response.statusCode == 200){
        return const Right('Carpeta actualizada exitosamente');
      }else{
        return Left(MyError(key: AppError.NotFound,message: response.body));
      }

  }catch(e){
      return Left(MyError(key: AppError.NotFound,message: '$e'));
  }  

  }
  
  @override
  Future<Either<MyError, folder>> getDefaultFolder(String idUser) async  {
    var res = await getALLfolders(idUser);
      if (res.isLeft){
        return Left(res.left);
      }
    for (var folder in res.right){
      if (folder.predeterminada){
        return Right(folder);
      }
    }
    return const Left(MyError(key: AppError.NotFound,message: 'carpeta no encontrada'));  
  }

@override
Future<Either<MyError, String>> deleteCarpeta(String idCarpeta) async {    
     var body = jsonEncode({
        "idCarpeta": idCarpeta,
      });
  Response r1;
  try{
   r1 = await delete(Uri.parse('http://$domain/carpeta/delete'),
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
  return const Right('Carpeta eliminada exitosamente');     
}

  @override
Future<Either<MyError, List<Nota>>> getNotesByFolder(String idCarpeta) async {

    List<Nota> notas = [];
    List<etiqueta> etiquetas = [];
    Response response;
    var body = jsonEncode({
      "idCarpeta": idCarpeta
    });


    try{ 
     response = await post(Uri.parse('http://$domain/nota/findByFolder'),
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