import 'package:either_dart/either.dart';

import 'errores.dart';
import 'nota.dart';

class user{
 String id;
 String? nombre;
 String? correo;
 String? clave;
 DateTime? fechaNacimiento;

 user({required this.id});

   static Either<MyError,user> create({   
    required String i,
    required String nombre,
    required String correo,
    required String clave,
    required DateTime fechaNacimiento 
  }){
    user u = user(id: i);
    u.nombre = nombre;
    u.clave = clave;
    u.correo = correo;
    u.fechaNacimiento = fechaNacimiento;
    return (Right(u));
  }
 

}