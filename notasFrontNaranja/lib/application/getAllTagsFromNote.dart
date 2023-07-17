import 'package:either_dart/either.dart';
import 'package:either_dart/src/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/repositories/etiquetaRepository.dart';

import 'DTOS/cmdGetAllTagsFromNote.dart';

class getAllTagsFromNoteService extends service<cmdGetAllTagsNote,cmdGetAllTagsNote> {

  etiquetaRepository tagRepo;

  getAllTagsFromNoteService({required this.tagRepo});
  
  @override
  Future<Either<MyError, cmdGetAllTagsNote>> execute(cmdGetAllTagsNote params) async {

    if (params.nota.etiquetas == null){
      return const Left(MyError(key: AppError.EmpyOrNullTag,message: 'sin tags'));
    }
      if (params.nota.etiquetas!.isEmpty){
      return const Left(MyError(key: AppError.EmpyOrNullTag,message: 'sin tags'));
    }

     params.etiquetas = []; 

    for (var tag in params.nota.etiquetas!) {
      var serverTag = await tagRepo.getEtiquetaById(tag.id!);
        if (serverTag.isLeft) {
          return Left(serverTag.left);
        }
       params.etiquetas!.add(serverTag.right);        
    }
    return Right(params);
  }

  
}