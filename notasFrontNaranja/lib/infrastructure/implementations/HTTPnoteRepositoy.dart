import 'package:either_dart/src/either.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/domain/repositories/noteRepository.dart';

class httpNoteRepository implements noteRepository{
  
  @override
  Either<MyError, Nota> createNota(Nota note) {
    
    
    throw UnimplementedError();


  }
  
}