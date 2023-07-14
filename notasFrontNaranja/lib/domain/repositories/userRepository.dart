import 'package:either_dart/either.dart';

import '../errores.dart';
import '../user.dart';

abstract class userRepository {
 
 Future<Either<MyError,user>>saveUser(user u);
 Future<Either<MyError,user>>getUser();
 Future<Either<MyError,user>>updateUser(user u);
 Future<Either<MyError,user>>deleteUser(user u);
 Future<Either<MyError,user>>getUserByEmailAndPass(String email,String pass);


}