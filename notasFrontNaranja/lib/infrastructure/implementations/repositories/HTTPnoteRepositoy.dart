// ignore_for_file: file_names, implementation_imports
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
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

    MultipartRequest request;
    StreamedResponse response;

    //Uint8List buffer = note.imagenes![0];
    //final tempDir = await getTemporaryDirectory();
    //File file = await File('${tempDir.path}/image.png').create(); 
    //file.writeAsBytesSync(buffer);
    

    var uri = Uri.parse('http://$domain/nota/create');


    request = MultipartRequest('POST',uri)
    ..fields['titulo'] = note.getTitulo
    ..fields['estado'] = note.getEstado
    ..fields['cuerpo'] = note.getContenido
    ..fields['fechaCreacion'] = note.getDate.toString()
    ..fields['fechaModificacion'] = note.getEditDate.toString()
    ..fields['longitud'] = note.getLongitud.toString()
    ..fields['latitud'] = note.getLatitud.toString()
    ..fields['idCarpeta'] = 'fa378750-9763-4466-902f-26200a4fc603';

    List<Uint8List>? imagenes = note.imagenes;

    if (imagenes != null){
      int cont = 0;
      for (Uint8List buffer in imagenes){
          final tempDir = await getTemporaryDirectory();
          File file = await File('${tempDir.path}/${note.getid}Image$cont.png').create(); 
          file.writeAsBytesSync(buffer);
          request.files.add( MultipartFile(
                              'imagen',file.readAsBytes().asStream(),
                               file.lengthSync(),
                               filename: file.path));
         cont++;
      }
    }
 

    response = await request.send();   

    if (response.statusCode == 200){    
      return Right(await response.stream.bytesToString());
    }                   


    String error = 'error al procesar la solicitud al servidor: ${response.stream.bytesToString()}';
         return Left(MyError(key: AppError.NotFound,
                                  message: error));
 }
 
  @override
  Future<Either<MyError, List<Nota>>> getALLnotes() async {

    List<Nota> notas = [];
    List<Uint8List> images = [];
    Response response;
    Response response1;


    try{ 
      response = await get(Uri.parse('http://$domain/nota/findAll'));
      response1 = response;
    }catch(e){
      return Left(MyError(key: AppError.NotFound,
                                  message: "$e"));
    }

   
   if (response1.statusCode == 200){

      var jsonData = json.decode(response1.body);

      for (var jsonNote in jsonData){

       for (var jsonImage in jsonNote['cuerpo']['imagen']){
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
                     imagenes: images                                
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
        images = [];
      } 
      return Right(notas);
    }
          
    return Left(MyError(key: AppError.NotFound,
                message: response.body ));
                
}

@override
Future<Either<MyError, String>> updateNota(Nota note) async {

    MultipartRequest request;
    StreamedResponse response;

    //Uint8List buffer = note.imagenes![0];
    //final tempDir = await getTemporaryDirectory();
    //File file = await File('${tempDir.path}/image.png').create(); 
    //file.writeAsBytesSync(buffer);
    

    var uri = Uri.parse('http://$domain/nota/modificate');


   request = MultipartRequest('PUT',uri)
    ..fields['titulo'] = note.getTitulo
    ..fields['estado'] = note.getEstado
    ..fields['cuerpo'] = note.getContenido
    ..fields['fechaCreacion'] = note.getDate.toString()
    ..fields['fechaModificacion'] = note.getEditDate.toString()
    //..fields['longitud'] = note.getLongitud.toString()
    //..fields['latitud'] = note.getLatitud.toString()
    ..fields['idCarpeta'] = 'fa378750-9763-4466-902f-26200a4fc603'
    ..fields['idNota'] = note.getid;

        if (note.latitud != null && note.longitud != null){
            request.fields['longitud'] = note.getLatitud.toString();
            request.fields['latitud'] = note.getLongitud.toString();
         }

    List<Uint8List>? imagenes = note.imagenes;

    if (imagenes != null){
      int cont = 0;
      for (Uint8List buffer in imagenes){
          final tempDir = await getTemporaryDirectory();
          File file = await File('${tempDir.path}/${note.getid}Image$cont.png').create(); 
          file.writeAsBytesSync(buffer);
          request.files.add( MultipartFile(
                              'imagen',file.readAsBytes().asStream(),
                               file.lengthSync(),
                               filename: file.path));
         cont++;
      }
    }
 

   try{
    response = await request.send();  
   }catch(e){
    return Left(MyError(key: AppError.NotFound,
                message: "$e" ));
   }

    if (response.statusCode == 200){    
      return Right(await response.stream.bytesToString());
    } 

    var res = response.stream.bytesToString();                  


    String error = 'error al procesar la solicitud al servidor: $res';
         return Left(MyError(key: AppError.NotFound,
                                  message: error));
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