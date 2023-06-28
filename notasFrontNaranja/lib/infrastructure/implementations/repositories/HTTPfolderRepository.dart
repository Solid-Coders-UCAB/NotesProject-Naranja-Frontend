import 'dart:convert';

import 'package:either_dart/src/either.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/folder.dart';
import 'package:firstapp/domain/repositories/folderRepository.dart';
import 'package:http/http.dart';

class HTTPfolderRepository implements folderRepository {

  String domain = '192.168.1.2:3000';
  
  @override
  Future<Either<MyError, String>> createFolder(folder folder) async {
    
    var body = jsonEncode({
    "nombre": folder.name,
  });

  try{

  final Response response = await post(Uri.parse('http://$domain/carpeta/create'),

      body: body,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      });

      if (response.statusCode == 200){
        return const Right('carpeta guardada exitosamente');
      }else{
        return Left(MyError(key: AppError.NotFound,message: response.body));
      }

  }catch(e){
      return Left(MyError(key: AppError.NotFound,message: '$e'));
  }  

  }

  @override
  Future<Either<MyError, List<folder>>> getALLfolders() async {

  Response response1;
  List<folder> folders = [];

  try{
   var response = await get(Uri.parse('http://$domain/carpeta/findAll'));
   response1 = response;
  }catch(e){
    return Left(MyError(key: AppError.NotFound,message: '$e'));
  }

  if (response1.statusCode == 200){

   var jsonData = json.decode(response1.body);    

    for (var jsonFolder in jsonData){
      var f = folder.create(name: jsonFolder['nombre']['nombre'],
                    id:   jsonFolder['id']['UUID']);
      folders.add(f.right);              
    }

    return Right(folders);

  }else{
   return Left(MyError(key: AppError.NotFound,message: response1.body));
  }

  }
  
}