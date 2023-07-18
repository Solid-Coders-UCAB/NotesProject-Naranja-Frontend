// ignore_for_file: camel_case_types

import 'package:either_dart/either.dart';
import 'package:either_dart/src/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/domain/repositories/userRepository.dart';

import 'package:firstapp/infrastructure/implementations/repositories/HTTPnoteRepositoy.dart';

class getAllNotEliminatedPreviewFromServerService  implements service<void,List<Nota>>{
  
  httpNoteRepository noteRepo;
  userRepository localUserRepo;

  getAllNotEliminatedPreviewFromServerService({required this.noteRepo,required this.localUserRepo});

  @override
  Future<Either<MyError, List<Nota>>> execute(params) async {

    var user = await localUserRepo.getUser();
      if (user.isLeft){
        return Left(user.left); 
    }
    
    var notes = await noteRepo.getALLnotesPreview(user.right.id);
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