import 'package:either_dart/either.dart';

import '../errores.dart';
import '../user.dart';

abstract class userRepository {
  Future<Either<MyError, user>> saveUser(user u);
  Future<Either<MyError, user>> getUser();
  Future<Either<MyError, String>> updateUser(user u);
  Future<Either<MyError, user>> deleteUser(user u);
  Future<Either<MyError, user>> getUserByEmailAndPass(
      String email, String pass);
  Future<Either<MyError, user>> getUserById(String idUsuario);
  Future<Either<MyError, String>> createSuscription(String idUsuario);
}
