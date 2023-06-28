// ignore_for_file: camel_case_types

import 'package:either_dart/either.dart';
import 'package:either_dart/src/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/domain/repositories/noteRepository.dart';

class getAllNotEliminatedNotesFromServerService  implements service<void,List<Nota>>{
  
  noteRepository noteRepo;

  getAllNotEliminatedNotesFromServerService({required this.noteRepo});

  @override
  Future<Either<MyError, List<Nota>>> execute(params) async {
    
    var notes = await noteRepo.getALLnotes();
    List<Nota> NotEliminatedNotes = [];

      if (notes.isLeft){
        return Left(notes.left);
      }

    for (var note in notes.right){
      if (note.estado != 'Eliminada'){
       NotEliminatedNotes.add(note);
      }
    }

      return Right(NotEliminatedNotes);

  }
  
}