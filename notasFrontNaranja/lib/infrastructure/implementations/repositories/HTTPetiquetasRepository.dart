import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:either_dart/src/either.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/etiqueta.dart';
import 'package:firstapp/domain/repositories/etiquetaRepository.dart';
import 'package:http/http.dart';

class HTTPetiquetasRepository implements etiquetaRepository {

  String domain = '192.168.0.103:3000';


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
      var f = etiqueta.create(nombre: jsonFolder['nombre']['nombre'],
                    idUsuario:   jsonFolder['usuario']['UUID'],
                    id: jsonFolder['id']['id']
                    );

      etiquetas.add(f.right);              
    }

    return Right(etiquetas);

  }else{
   return Left(MyError(key: AppError.NotFound,message: response1.body));
  }

  }
  
}