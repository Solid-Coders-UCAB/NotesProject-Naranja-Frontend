import 'package:either_dart/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/repositories/userRepository.dart';
import 'package:firstapp/domain/user.dart';
import 'package:firstapp/infrastructure/implementations/repositories/HTTPuserRepository.dart';
import 'package:firstapp/infrastructure/implementations/repositories/localUserRepository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'DTOS/cmdCreateUser.dart';


class createUserService implements service<cmdCreateUser,cmdCreateUser>{
 userRepository serverRepo,localRepo;

 createUserService({required this.serverRepo,required this.localRepo});

  @override
  Future<Either<MyError, cmdCreateUser>> execute(params) async  {
    var u = user.create(i: '', isSuscribed: params.isSuscribed,nombre: params.nombre, correo: params.correo, clave: params.clave, fechaNacimiento: params.fechaNacimiento);
      if (u.isLeft){
        return Left(u.left);
      }
    var serverRes = await serverRepo.saveUser(u.right);
        if (serverRes.isRight){
          var userFromServer = await serverRepo.getUserByEmailAndPass(params.correo, params.clave);
              if (userFromServer.isLeft){
               return(Left(userFromServer.left));
             }
          var localres = await localRepo.saveUser(userFromServer.right); 
            if (localres.isLeft){
              return(Left(localres.left));
            }

           return Right(params);   
        }

    return Left(serverRes.left);
  } 
}

void main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  
  var sut = createUserService(serverRepo: httpUserRepository(), localRepo: localUserRepository()); 
  var execute = await sut.execute(cmdCreateUser(nombre: 'prueba14/07', correo: 'prueba1407@gmail.com', clave: '23041614d', fechaNacimiento: DateTime.now()));

    if (execute.isRight){
      print(execute.right);
    }else{
      print(execute.left.message);
    }


}
