import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:either_dart/src/either.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/etiqueta.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/domain/repositories/etiquetaRepository.dart';
import 'package:firstapp/infrastructure/implementations/repositories/HTTPrepository.dart';
import 'package:http/http.dart';
import 'package:firstapp/domain/tarea.dart';

class HTTPetiquetasRepository extends HTTPrepository implements etiquetaRepository {

  @override
  Future<Either<MyError, String>> createEtiqueta(etiqueta etiqueta) async {
    
    var body = jsonEncode({
    "nombreEtiqueta": etiqueta.nombre,
    "idUsuario": etiqueta.idUsuario
  });

  try{

  final Response response = await post(Uri.parse('http://$domain/etiqueta/create'),

      body: body,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      });

      if (response.statusCode == 200){
        return const Right('Etiqueta guardada exitosamente');
      }else{
        return Left(MyError(key: AppError.NotFound,message: response.body));
      }

  }catch(e){
      return Left(MyError(key: AppError.NotFound,message: '$e'));
  }  

  }

  @override
  Future<Either<MyError, List<etiqueta>>> getAllEtiquetas(String idUsuario) async {

  Response response1;
  List<etiqueta> etiquetas = [];
  var body = jsonEncode({
    "idUsuario": idUsuario,
  });

  try{
      response1 = await post(Uri.parse('http://$domain/etiqueta/findByUser'),
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
      var f = etiqueta.create(id: jsonFolder['id']['id'],
                              nombre: jsonFolder['nombre']['nombre'],
                              idUsuario:   jsonFolder['usuario']['UUID'] 
                    );

      etiquetas.add(f.right);              
    }
    
    return Right(etiquetas);

  }else{
   return Left(MyError(key: AppError.NotFound,message: response1.body));
  }

  }

  @override
  Future<Either<MyError, String>> updateEtiqueta(etiqueta etiqueta) async {
    
    var body = jsonEncode({
    "idEtiqueta": etiqueta.id.toString(),
    "nombreEtiqueta": etiqueta.nombre,
    "idUsuario": etiqueta.idUsuario
  });

  try{

  final Response response = await put(Uri.parse('http://$domain/etiqueta/modificate'),

      body: body,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      });

      if (response.statusCode == 200){
        return const Right('Etiqueta actualizada exitosamente');
      }else{
        return Left(MyError(key: AppError.NotFound,message: response.body));
      }

  }catch(e){
      return Left(MyError(key: AppError.NotFound,message: '$e'));
  }  

  }

@override
Future<Either<MyError, String>> deleteEtiqueta(String idEtiqueta) async {    
     var body = jsonEncode({
        "idEtiqueta": idEtiqueta,
      });
  Response r1;
  try{
   r1 = await delete(Uri.parse('http://$domain/etiqueta/delete'),
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
  return const Right('Etiqueta eliminada exitosamente');     
}

  @override
  Future<Either<MyError, etiqueta>> getEtiquetaById(String idEtiqueta) async {
    var body = jsonEncode({
     "idEtiqueta": idEtiqueta,
    });

  try{

    final Response response = await post(Uri.parse('http://$domain/etiqueta/findById'),

      body: body,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      });

      if (response.statusCode == 200){
        var jsonData = jsonDecode(response.body);
        etiqueta eti = etiqueta(nombre: jsonData['nombre']['nombre'], idUsuario: '',id: idEtiqueta);
        print(eti.nombre);
        return Right(eti);
      }else{
        return Left(MyError(key: AppError.NotFound,message: response.body));
      }

  }catch(e){
      return Left(MyError(key: AppError.NotFound,message: '$e'));
  } 

  }

@override
Future<Either<MyError, List<Nota>>> getNotesByEtiqueta(String idEtiqueta, String idUsuario) async {

    List<Nota> notas = [];
    List<etiqueta> etiquetas = [];
    List<tarea> tareas = [];

    Response response;
    var body = jsonEncode({
      "idEtiqueta": idEtiqueta,
      "idUsuario": idUsuario
    });


    try{ 
     response = await post(Uri.parse('http://$domain/nota/findByTag'),
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
       
       // Obtener las tareas de la nota
          for (var jsonTarea in jsonNote['tareas']) {
            String nombreTarea = jsonTarea['nombre']['nombre'];
            bool completada = jsonTarea['completada'];
            tareas.add(tarea(nombreTarea: nombreTarea, completada: completada));
          }

       Nota nota =  Nota.create( id: jsonNote['id']['UUID'],
                     titulo: jsonNote['titulo']['titulo'],
                     contenido: jsonNote['cuerpo']['cuerpo'],
                     n_edit_date: DateTime.tryParse(jsonNote['fechaModificacion']['fecha']),
                     n_date: DateTime.tryParse(jsonNote['fechaCreacion']['fecha']) ,
                     estado: jsonNote['estado'], 
                     carpeta: jsonNote['idCarpeta']['UUID'],
                     etiquetas: etiquetas,
                     tareas: tareas                           
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
        tareas = [];
      } 
      return Right(notas);
    }
          
    return Left(MyError(key: AppError.NotFound,
                message: response.body ));
                
}
  
}