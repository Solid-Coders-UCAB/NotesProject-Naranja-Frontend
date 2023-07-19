import 'dart:convert';

import 'package:either_dart/src/either.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/repositories/userRepository.dart';
import 'package:firstapp/domain/user.dart';
import 'package:firstapp/infrastructure/implementations/repositories/HTTPrepository.dart';
import 'package:http/http.dart';

class httpUserRepository extends HTTPrepository implements userRepository {
  @override
  Future<Either<MyError, user>> deleteUser(user u) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, user>> getUser() {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, user>> saveUser(user u) async {
    Response res;
    var body = jsonEncode({
      "id": u.id,
      "nombre": u.nombre,
      "correo": u.correo,
      "clave": u.clave,
      "fechaNacimiento": u.fechaNacimiento.toString(),
      "suscripcion": u.isSuscribed
    });
    try {
      res = await post(Uri.parse('http://$domain/usuario/create'),
          body: body,
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          });
    } catch (e) {
      return Left(MyError(key: AppError.NotFound, message: '$e'));
    }

    if (res.statusCode == 200) {
      return Right(u);
    } else {
      return Left(MyError(key: AppError.NotFound, message: res.body));
    }
  }

  @override
  Future<Either<MyError, user>> getUserByEmailAndPass(
      String email, String pass) async {
    Response res;
    var body = jsonEncode({
      "correo": email,
      "clave": pass,
    });

    Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };

    try {
      res = await post(Uri.parse('http://$domain/usuario/findByEmailPassword'),
          headers: headers, body: body);
    } catch (e) {
      return Left(MyError(key: AppError.NotFound, message: '$e'));
    }

    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);
      var u = user(
          id: jsonData['id']['UUID'], isSuscribed: jsonData['suscripcion']);
      u.clave = jsonData['clave']['clave'];
      u.correo = jsonData['correo']['correo'];
      u.fechaNacimiento = jsonData['fechaNacimiento']['fechaNacimiento'];
      return Right(u);
    } else {
      return Left(MyError(key: AppError.NotFound, message: res.body));
    }
  }

  @override
  Future<Either<MyError, user>> updateUser(user u) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, user>> getUserById(String idUsuario) async {
    Response res;
    var body = jsonEncode({"idUsuario": idUsuario});

    Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };

    try {
      res = await post(Uri.parse('http://$domain/usuario/findById'),
          headers: headers, body: body);
    } catch (e) {
      return Left(MyError(key: AppError.NotFound, message: '$e'));
    }

    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);
      var u = user(
          id: jsonData['id']['UUID'], isSuscribed: jsonData['suscripcion']);
      u.clave = jsonData['clave']['clave'];
      u.correo = jsonData['correo']['correo'];
      u.fechaNacimiento = jsonData['fechaNacimiento']['fechaNacimiento'];
      return Right(u);
    } else {
      return Left(MyError(key: AppError.NotFound, message: res.body));
    }
  }
}

void main() async {
  var repo = httpUserRepository();
  var res =
      await repo.getUserByEmailAndPass('starspipo1@gmail.com', '23041614d');
  if (res.isLeft) {
    print(res.left.message);
  }
  print(res.right.id);
}
