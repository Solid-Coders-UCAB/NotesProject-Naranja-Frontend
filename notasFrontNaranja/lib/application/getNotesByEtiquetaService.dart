// ignore_for_file: camel_case_types
import 'package:either_dart/either.dart';
import 'package:either_dart/src/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/domain/repositories/etiquetaRepository.dart';
import 'package:firstapp/domain/repositories/userRepository.dart';
import 'package:firstapp/application/DTOS/getNotesByEtiquetaDTO.dart';

class getNotesByEtiquetaService  implements service<getNotesByEtiquetaDTO,List<Nota>>{
  
  etiquetaRepository etiquetaRepo;
  userRepository localUserRepo;

  getNotesByEtiquetaService({required this.etiquetaRepo,required this.localUserRepo});

  @override
  Future<Either<MyError, List<Nota>>> execute(params) async {

    var user = await localUserRepo.getUser();
      if (user.isLeft){
        return Left(user.left); 
    }
    
    var notes = await etiquetaRepo.getNotesByEtiqueta(params.getId(), user.right.id);
    List<Nota> FolderNotes = [];

      if (notes.isLeft){
        return Left(notes.left);
      }

    for (var note in notes.right){
       FolderNotes.add(note);
    }

      return Right(FolderNotes);

  }
  
}