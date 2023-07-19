// ignore_for_file: file_names, camel_case_types

import 'package:either_dart/either.dart';
import 'package:either_dart/src/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/repositories/folderRepository.dart';
import 'package:firstapp/domain/repositories/userRepository.dart';
//pruebas
import 'package:firstapp/infrastructure/implementations/repositories/HTTPfolderRepository.dart';
import 'package:firstapp/infrastructure/implementations/repositories/HTTPnoteRepositoy.dart';
import 'package:firstapp/infrastructure/implementations/repositories/localUserRepository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
//
import '../domain/nota.dart';
import 'DTOS/createNoteParams.dart';
import '../domain/repositories/noteRepository.dart';



class createNoteInServerService implements service<CreatenoteParams,String>{
  
  noteRepository noteRepo;
  folderRepository folderRepo; 
  userRepository localUserRepo;

  createNoteInServerService( { required this.noteRepo , required this.folderRepo, required this.localUserRepo });

  @override
  Future<Either<MyError, String>> execute(params) async {

    var localId = await localUserRepo.getUser();
      if(localId.isLeft){
        return Left(localId.left);
      }  

    if (params.folderId == null){
      var folderResponse = await folderRepo.getDefaultFolder(localId.right.id);
        if (folderResponse.isLeft){
          return Left(folderResponse.left);
        }
      params.folderId = folderResponse.right.id;  
    }
    
    Either<MyError,Nota> note = Nota.create( //creamos nota
      titulo: params.getTitulo , 
      contenido: params.getContenido , 
      n_date: DateTime.now(),
      n_edit_date:  DateTime.now(),
      estado: 'guardada',
      longitud: params.getLongitud,
      latitud: params.getLatitud,
      imagenes: params.imagenes,
      carpeta: params.folderId,
      etiquetas: params.etiquetas, 
      id: '', tareas: params.getTareas
    );

    if (note.isLeft){         //error al crear la nota
      return Left(note.left);
    }

    var response = await noteRepo.createNota(note.right); //guardamos nota

      if (response.isLeft){  //error al guardar la nota
        return Left(response.left);
      }

    return Right(response.right);
  }

}

void main() async {

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  var sut = createNoteInServerService(noteRepo: httpNoteRepository(), folderRepo: HTTPfolderRepository(), localUserRepo: localUserRepository());
  var exec = await sut.execute(CreatenoteParams(contenido: 'CONTENIDO1', titulo: 'TITULO1', tareas: []));
    if (exec.isRight){
      print(exec.right);
    }else{
      print(exec.left.message);
    }
}