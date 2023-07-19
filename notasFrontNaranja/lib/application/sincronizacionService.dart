import 'package:either_dart/src/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/application/connectionCheckerDecorator.dart';
import 'package:firstapp/database.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/etiqueta.dart';
import 'package:firstapp/domain/folder.dart';
import 'package:firstapp/domain/repositories/etiquetaRepository.dart';
import 'package:firstapp/domain/repositories/folderRepository.dart';
import 'package:firstapp/domain/repositories/noteRepository.dart';
import 'package:firstapp/domain/repositories/userRepository.dart';


import '../domain/nota.dart';

class sincronizacionService extends service {
  
  userRepository localUserRepo;
  etiquetaRepository localEtiquetaRepo,serverEtiquetaRepo;
  noteRepository localNoteRepo,serverNoteRepo;
  folderRepository localfolderrepo,serverFolderRepo;
  connectionChecker checker;

 sincronizacionService({required this.localNoteRepo,required this.serverNoteRepo,required,
  required this.localfolderrepo, required this.serverFolderRepo,
  required this.localUserRepo,
  required this.localEtiquetaRepo,required this.serverEtiquetaRepo,
  required this.checker});

  @override
  Future<Either<MyError, dynamic>> execute(params) async {
    var hasConnection = await checker.checkConnection();
    if (!(hasConnection)) { 
      return const Left(MyError(key: AppError.NotFound,message: 'no se puedo realizar la sincronizacion por falta de conexion')); 
    }
    var userRes = await localUserRepo.getUser();
    var userId = '';
     if (userRes.isLeft){
     return Left(userRes.left);
     }else{
      userId = userRes.right.id;
     }

    var localFolderRes = await localfolderrepo.getALLfolders(userId);
      if (localFolderRes.isRight){
          List<folder> folders = localFolderRes.right;
         for (var fol in folders){
            if (fol.savedInServer == 0){
              var folderRes = await serverFolderRepo.createFolder(fol);
              if (folderRes.isLeft) { return Left(folderRes.left);}
            }
         }
      }else{
        return Left(localFolderRes.left);
    }

    var localEtiquetaRes = await localEtiquetaRepo.getAllEtiquetas(userId);
      if (localEtiquetaRes.isRight){
          List<etiqueta> tags = localEtiquetaRes.right;
         for (var tag in tags){
            if (tag.savedInServer == 0){
              var tagRes = await serverEtiquetaRepo.createEtiqueta(tag);
              if (tagRes.isLeft) { return Left(tagRes.left);}
            }
         }
      }else{
        return Left(localFolderRes.left);
    }
        
    var localNoteResponse = await localNoteRepo.getALLnotes('');
      if (localNoteResponse.isRight){
        List<Nota> localNotes = localNoteResponse.right;
          for (var nota in localNotes){
              if(nota.savedInServer == 0){
                if (nota.idCarpeta == '1'){
                  var folderRes = await serverFolderRepo.getDefaultFolder(userId);
                    if (folderRes.isRight){
                      nota.idCarpeta = folderRes.right.id!;
                    }else { return Left(folderRes.left);}
                }
                var serverRes = await  serverNoteRepo.createNota(nota);
                  if (serverRes.isRight){
                      //hacer un update a SavedInServer de la nota
                  }else{
                      return Left(serverRes.left);
                  }
              }
          }
      }else{
        return Left(localNoteResponse.left);
      }

    await database.deleteNoteTable();
    await database.deleteCarpetaTable();

    return const Right('mensaje exitioso');
  }


}