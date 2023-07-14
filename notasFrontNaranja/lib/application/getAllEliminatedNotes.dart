

// ignore_for_file: camel_case_types

import 'package:either_dart/either.dart';
import 'package:firstapp/domain/repositories/userRepository.dart';

import '../domain/errores.dart';
import '../domain/nota.dart';
import '../domain/repositories/noteRepository.dart';
import 'Iservice.dart';

class getAllEliminatedNotesFromServerService  implements service<void,List<Nota>>{
  
  noteRepository noteRepo;
  userRepository localUserRepo;

  getAllEliminatedNotesFromServerService({required this.noteRepo,required this.localUserRepo});

  @override
  Future<Either<MyError, List<Nota>>> execute(params) async {

    var user = await localUserRepo.getUser();
      if (user.isLeft){
        return Left(user.left); 
      }
       
    var notes = await noteRepo.getALLnotes(user.right.id);
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