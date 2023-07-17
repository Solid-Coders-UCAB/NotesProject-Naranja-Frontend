// ignore_for_file: file_names
import 'package:either_dart/src/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';

import '../domain/nota.dart';
import 'DTOS/updateNoteParams.dart';
import '../domain/repositories/noteRepository.dart';



class updateNoteInServerService implements service<UpdateNoteParams,String>{
  
  noteRepository noteRepo; 

  updateNoteInServerService( { required this.noteRepo });

  @override
  Future<Either<MyError, String>> execute(params) async {
    //creamos una nota
    Either<MyError,Nota> note = Nota.create( 
      titulo: params.getTitulo , 
      contenido: params.getContenido , 
      n_date: params.getDate,
      n_edit_date:  DateTime.now(),
      estado: params.estado,
      longitud: params.getLongitud,
      latitud: params.getLatitud,
      imagenes: params.imagenes,
      id: params.idNota,
      carpeta: params.idCarpeta,
      etiquetas: params.etiquetas
    );

  //error al crear la nota
    if (note.isLeft){         
      return Left(note.left);
    }

  //se guarda la nota
    var response = await noteRepo.updateNota(note.right); 

      if (response.isLeft){  //error al guardar la nota
        return Left(response.left);
      }

    return Right(response.right);
  }


}