// ignore_for_file: file_names

import 'package:either_dart/src/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';

import '../domain/nota.dart';
import '../domain/parameterObjects/createNoteParams.dart';
import '../domain/repositories/noteRepository.dart';



class createNoteInServerService implements service<CreatenoteParams,String>{
  
  noteRepository noteRepo; 

  createNoteInServerService( { required this.noteRepo });

  @override
  Future<Either<MyError, String>> execute(params) async {
    
    Either<MyError,Nota> note = Nota.create( //creamos nota
      titulo: params.getTitulo , 
      contenido: params.getContenido , 
      n_date: DateTime.now(),
      n_edit_date:  DateTime.now(),
      estado: 'guardada',
      longitud: params.getLongitud,
      latitud: params.getLatitud,
      imagenes: params.imagenes
    );

    if (note.isLeft){         //error al crear la nota
      return Left(note.left);
    }

    var response = await noteRepo.createNota(note.right); //guardamos nota

      if (response.isLeft){  //error al guardar la nota
        return Left(response.left);
      }

    return Right(response.right);
  }

  




}