import 'package:either_dart/src/either.dart';
import 'package:firstapp/database.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/folder.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/domain/repositories/folderRepository.dart';

class localFolderRepository implements folderRepository {
  
  @override
  Future<Either<MyError, String>> createFolder(folder folder) {
    // TODO: implement createFolder
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, String>> deleteCarpeta(String idCarpeta) {
    // TODO: implement deleteCarpeta
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, List<folder>>> getALLfolders(String userId) {
    // TODO: implement getALLfolders
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, folder>> getDefaultFolder(String userId) async {
    var bd = await  database.getDatabase();
    List<Map> folders = [];
    try{
      folders = await bd.rawQuery('SELECT * FROM carpeta WHERE (predeterminada = 1)');
      return Right( folder(id: folders.first['id'],name: folders.first['nombre'], idUsuario: userId, 
      predeterminada: (folders.first['predeterminada'] == 1)));
    }catch(e){
      return Left(MyError(key: AppError.NotFound,message: e.toString()));
    }
  }

  @override
  Future<Either<MyError, List<Nota>>> getNotesByFolder(String idCarpeta) {
    // TODO: implement getNotesByFolder
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, String>> updateFolder(folder folder) {
    // TODO: implement updateFolder
    throw UnimplementedError();
  }
  
}