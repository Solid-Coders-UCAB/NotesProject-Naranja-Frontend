import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:either_dart/src/either.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/etiqueta.dart';
import 'package:firstapp/domain/repositories/etiquetaRepository.dart';
import 'package:firstapp/infrastructure/implementations/repositories/HTTPrepository.dart';
import 'package:http/http.dart';

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
  print(etiqueta.id);
  print(etiqueta.idUsuario);
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
  
}