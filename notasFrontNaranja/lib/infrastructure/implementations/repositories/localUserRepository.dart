

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:either_dart/src/either.dart';


import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/repositories/userRepository.dart';
import 'package:firstapp/domain/user.dart';

class localUserRepository implements userRepository{

 String? patch;

Future<Database> openBD() async {
  var databasesPath = await getDatabasesPath();
  String p = join(databasesPath, 'notesApp.db');
  patch = p;
  print(patch);

  return await openDatabase(p, version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE User (id TEXT PRIMARY KEY, name TEXT)');
      });
  }
  
  @override
  Future<Either<MyError, user>> deleteUser(user u) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, user>> saveUser(user u) async {
    var database = await openBD();
 try{   
    await database.transaction((txn) async {
      await txn.execute('DELETE FROM User');
      await txn.rawInsert(
      'INSERT INTO User(id, name) VALUES("${u.id}", "${u.nombre}")');      
    });
    }catch(e){
      await database.close();
      return Left(MyError(key: AppError.NotFound,message: e.toString()));
  }  

    await database.close();

    return Right(u);
  }

  @override
  Future<Either<MyError, user>> updateUser(user u) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
  
  @override
  Future<Either<MyError, user>> getUser() async {
    var database = await openBD();
    List<Map> users;
    try{
      users = await database.rawQuery('SELECT * FROM User');
      return Right( user(id: users.first['id']));
    }catch(e){
      return Left(MyError(key: AppError.NotFound,message: e.toString()));
    }
  }
  
  @override
  Future<Either<MyError, user>> getUserByEmailAndPass(String email, String pass) {
    // TODO: implement getUserByEmailAndPass
    throw UnimplementedError();
  }
  
  
}

Future<void> main() async {

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  var repo = await localUserRepository().getUser();
    if (repo.isLeft){
      print(repo.left.message);
    }else{
      print(repo.right.id);
    }
}