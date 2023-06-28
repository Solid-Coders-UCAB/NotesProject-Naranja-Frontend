

// ignore_for_file: camel_case_types

import 'package:either_dart/either.dart';

import '../domain/errores.dart';
import '../domain/nota.dart';
import '../domain/repositories/noteRepository.dart';
import 'Iservice.dart';

class getAllEliminatedNotesFromServerService  implements service<void,List<Nota>>{
  
  noteRepository noteRepo;

  getAllEliminatedNotesFromServerService({required this.noteRepo});

  @override
  Future<Either<MyError, List<Nota>>> execute(params) async {
    
    var notes = await noteRepo.getALLnotes();
    List<Nota> EliminatedNotes = [];

      if (notes.isLeft){
        return Left(notes.left);
      }
    //
    for (var note in notes.right){
      if (note.estado == 'Eliminada'){
       EliminatedNotes.add(note);
      }
    }
    //
      return Right(EliminatedNotes);

  }
  
}