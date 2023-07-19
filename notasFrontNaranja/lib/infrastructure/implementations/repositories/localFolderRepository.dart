import 'package:either_dart/src/either.dart';
import 'package:firstapp/database.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/folder.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/domain/repositories/folderRepository.dart';
import 'package:uuid/uuid.dart';
import '../connectionCheckerImp.dart';

class localFolderRepository implements folderRepository {
  
  @override
  Future<Either<MyError, String>> createFolder(folder folder) async{
      var bd = await database.getDatabase();
      var uuid = const Uuid();
      var v1 = uuid.v1();
      var hasConneccion = await connectionCheckerImp().checkConnection();

      (hasConneccion) ? folder.savedInServer = 1 : folder.savedInServer = 0;
      print("savedInserver: ${folder.savedInServer}");

    try{   
      await bd.transaction((txn) async {
        await txn.rawInsert('''INSERT INTO carpeta(id,savedInServer,predeterminada,nombre) 
        VALUES("$v1",${folder.savedInServer},"${folder.predeterminada}","${folder.name}")''');
    
      });
      }catch(e){
        await bd.close();
        return Left(MyError(key: AppError.NotFound,message: e.toString()));
      }
      await bd.close();
      return const Right('Carpeta guardada correctamente');
  }

  @override
  Future<Either<MyError, String>> deleteCarpeta(String idCarpeta) {
    // TODO: implement deleteCarpeta
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, List<folder>>> getALLfolders(String userId) async {
    var bd = await database.getDatabase();
    List<Map> folderMap = [];
    List<folder> folders = [];
    try{
      folderMap = await bd.rawQuery('SELECT * FROM carpeta');
      print("cantidad de notas en local:${folderMap.length}");
        if (folderMap.isNotEmpty){
          for (var carpeta in folderMap){
            var f = folder(id: carpeta['id'],
                     name: carpeta['nombre'],
                     predeterminada: carpeta['predeterminada'] == 1 ? true : false,
                     idUsuario: userId,
                    );         

          f.savedInServer = carpeta['savedInServer'];
            print("carpetaid:${f.name}");
            folders.add(f);  
          }
        }
        bd.close();
       return Right(folders);
    }catch(e){
      return Left(MyError(key: AppError.NotFound,message: e.toString()));
    }
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