// ignore_for_file: camel_case_types

import 'package:either_dart/either.dart';
import 'package:either_dart/src/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/domain/repositories/noteRepository.dart';

class getAllNotesFromServerService  implements service{
  
  noteRepository noteRepo;

  getAllNotesFromServerService({required this.noteRepo});

  @override
  Future<Either<MyError, List<Nota>>> execute(params) async {
    
    var notes = await noteRepo.getALLnotes();

      if (notes.isLeft){
        return Left(notes.left);
      }

      return Right(notes.right);

  }
  
}