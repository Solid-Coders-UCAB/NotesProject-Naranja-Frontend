import 'package:either_dart/either.dart';

import 'errores.dart';
import 'nota.dart';

class user{
 String id;
 String? nombre;
 String? correo;
 String? clave;
 DateTime? fechaNacimiento;
 bool isSuscribed; 

 user({required this.id,required this.isSuscribed});

   static Either<MyError,user> create({   
    required String i,
    required String nombre,
    required String correo,
    required String clave,
    required DateTime fechaNacimiento, 
    required bool isSuscribed
  }){
    user u = user(id: i,isSuscribed: isSuscribed);
    u.nombre = nombre;
    u.clave = clave;
    u.correo = correo;
    u.fechaNacimiento = fechaNacimiento;
    return (Right(u));
  }
 

}