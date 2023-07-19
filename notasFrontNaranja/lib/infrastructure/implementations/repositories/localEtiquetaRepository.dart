import 'package:either_dart/src/either.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/database.dart';
import 'package:firstapp/domain/etiqueta.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/domain/repositories/etiquetaRepository.dart';
import 'package:uuid/uuid.dart';

import '../connectionCheckerImp.dart';

class localEtiquetaRepository implements etiquetaRepository {
  
  @override
  Future<Either<MyError, String>> createEtiqueta(etiqueta etiqueta) async {
    var bd = await database.getDatabase();
    var uuid = const Uuid();
    var v1 = uuid.v1();
    var hasConneccion = await connectionCheckerImp().checkConnection();
    (hasConneccion) ? etiqueta.savedInServer = 1 : etiqueta.savedInServer = 0;
    print("savedInserver: ${etiqueta.savedInServer}");

   try{   
    await bd.transaction((txn) async {
      await txn.rawInsert('''INSERT INTO etiqueta(id,savedInServer,nombre) 
      VALUES("$v1",${etiqueta.savedInServer},"${etiqueta.nombre}" ''');    
    });
    }catch(e){
      await bd.close();
      return Left(MyError(key: AppError.NotFound,message: e.toString()));
   }
    await bd.close();
    return const Right('nota guardada correctamente');
  }

  @override
  Future<Either<MyError, String>> deleteEtiqueta(String idEtiqueta) {
    // TODO: implement deleteEtiqueta
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, List<etiqueta>>> getAllEtiquetas(String idUsuario) {
    // TODO: implement getAllEtiquetas
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, etiqueta>> getEtiquetaById(String idEtiqueta) {
    // TODO: implement getEtiquetaById
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, List<Nota>>> getNotesByEtiqueta(String idEtiqueta, String idUsuario) {
    // TODO: implement getNotesByEtiqueta
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, String>> updateEtiqueta(etiqueta etiqueta) {
    // TODO: implement updateEtiqueta
    throw UnimplementedError();
  }
  
}