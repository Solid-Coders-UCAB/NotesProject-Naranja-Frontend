import 'package:either_dart/src/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/repositories/noteRepository.dart';

import 'DTOS/cmdDeleteNote.dart';

class deleteNoteFromServerService extends service<cmdDeleteNote,cmdDeleteNote>{

  noteRepository noteRepo;

  deleteNoteFromServerService({required this.noteRepo});
  
  @override
  Future<Either<MyError, cmdDeleteNote>> execute(cmdDeleteNote params) async {
    var serverResponse = await noteRepo.deleteNota(params.nota);
      if (serverResponse.isLeft){
        return Left(serverResponse.left);
      }

     return Right(params); 
  }
  
}