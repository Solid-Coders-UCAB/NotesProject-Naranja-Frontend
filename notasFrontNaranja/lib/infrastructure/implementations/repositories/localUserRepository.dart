import 'package:firstapp/database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:either_dart/src/either.dart';

import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/repositories/userRepository.dart';
import 'package:firstapp/domain/user.dart';

class localUserRepository implements userRepository {
  String? patch;

  @override
  Future<Either<MyError, user>> deleteUser(user u) async {
    var bd = await database.getDatabase();
    try {
      await bd.transaction((txn) async {
        await txn.execute('DELETE FROM User');
      });
    } catch (e) {
      await bd.close();
      return Left(MyError(key: AppError.NotFound, message: e.toString()));
    }

    await bd.close();
    await deleteDatabase(bd.path);
    return Right(u);
  }

  @override
  Future<Either<MyError, user>> saveUser(user u) async {
    var bd = await database.getDatabase();
    try {
      await bd.transaction((txn) async {
        await txn.execute('DELETE FROM User');
        await txn.rawInsert(
            'INSERT INTO User(id, name) VALUES("${u.id}", "${u.nombre}")');
      });
    } catch (e) {
      await bd.close();
      return Left(MyError(key: AppError.NotFound, message: e.toString()));
    }

    await bd.close();

    return Right(u);
  }

  @override
  Future<Either<MyError, String>> updateUser(user u) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, user>> getUser() async {
    var bd = await database.getDatabase();
    List<Map> users;
    try {
      users = await bd.rawQuery('SELECT * FROM User');
      return Right(user(id: users.first['id'], isSuscribed: false));
    } catch (e) {
      return Left(MyError(key: AppError.NotFound, message: e.toString()));
    }
  }

  @override
  Future<Either<MyError, user>> getUserByEmailAndPass(
      String email, String pass) {
    // TODO: implement getUserByEmailAndPass
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, user>> getUserById(String idUsuario) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, String>> createSuscription(String idUsuario) {
    // TODO: implement createSuscription
    throw UnimplementedError();
  }
}

Future<void> main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  var repo = await localUserRepository().getUser();
  if (repo.isLeft) {
    print(repo.left.message);
  } else {
    print(repo.right.id);
  }
}
