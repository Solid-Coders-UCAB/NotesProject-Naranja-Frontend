// ignore_for_file: camel_case_types
import 'package:either_dart/either.dart';
import 'package:either_dart/src/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/domain/repositories/folderRepository.dart';
import 'package:firstapp/domain/repositories/userRepository.dart';
import 'package:firstapp/application/DTOS/getNotesByFolderDTO.dart';

class getNotesByFolderService  implements service<getNotesByFolderDTO,List<Nota>>{
  
  folderRepository folderRepo;
  userRepository localUserRepo;

  getNotesByFolderService({required this.folderRepo,required this.localUserRepo});

  @override
  Future<Either<MyError, List<Nota>>> execute(params) async {

    var user = await localUserRepo.getUser();
      if (user.isLeft){
        return Left(user.left); 
    }
    
    var notes = await folderRepo.getNotesByFolder(params.getId());
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