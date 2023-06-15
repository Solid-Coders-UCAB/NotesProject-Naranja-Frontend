// ignore_for_file: file_names, implementation_imports

import 'dart:convert';

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
    //"client": {"c_id": idclient}
   });
    //'http://192.168.0.102:3000/nota/create'
    final response = await post(Uri.parse('http://192.168.1.2:3000/nota/create'), //aqui colocar la red de tu compu local
      body: body,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      });

    if (response.statusCode != 201) {
      return const Left(MyError(key: AppError.NotFound,
                                message: 'error al procesar la solicitud al servidor'));
    }

    return Right(response.body);
    
  }
    
}