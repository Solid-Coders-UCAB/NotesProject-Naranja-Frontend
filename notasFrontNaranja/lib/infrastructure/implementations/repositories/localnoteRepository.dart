import 'package:either_dart/src/either.dart';
import 'package:firstapp/database.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/etiqueta.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/domain/repositories/noteRepository.dart';

import 'package:uuid/uuid.dart';

class localNoteRepository implements noteRepository {
  
  @override
  Future<Either<MyError, String>> createNota(Nota note) async {
    var bd = await database.getDatabase();
     var uuid = const Uuid();
    // Generate a v1 (time-based) id
    var v1 = uuid.v1();  

   try{   
    await bd.transaction((txn) async {
      await txn.rawInsert('''INSERT INTO nota(id,savedInServer,fechaModificacion,fechaCreacion,estado,titulo,cuerpo,longitud,latitud,idCarpeta) 
      VALUES("$v1",${note.savedInServer},"${note.n_edit_date}","${note.n_date}", "${note.estado}","${note.titulo}", 
      "${note.contenido}",${note.longitud}, ${note.latitud},"${note.idCarpeta}")''');
        
        if (note.etiquetas != null){
          if (note.etiquetas!.isNotEmpty){
            for (var etiqueta in note.etiquetas!) {
             await txn.rawInsert(''' INSERT INTO etiqueta(id,savedInServer,nombre) VALUES ("${etiqueta.id}",${etiqueta.savedInServer},"${etiqueta.nombre}")'''); 
             await txn.rawInsert(''' INSERT INTO nota_etiqueta(idEtiqueta,idNota) VALUES ("${etiqueta.id}", "${note.id}")'''); 
            }
          }
        }      
    });
    }catch(e){
      await bd.close();
      return Left(MyError(key: AppError.NotFound,message: e.toString()));
   }
    await bd.close();
    return const Right('nota guardada correctamente');
  }

  @override
  Future<Either<MyError, String>> deleteNota(Nota note) {
    // TODO: implement deleteNota
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, List<Nota>>> getALLnotes(String userId) async {
    var bd = await database.getDatabase();
    List<Map> notas = [];
    List<Nota> notes = [];
    try{
      notas = await bd.rawQuery('SELECT * FROM nota');
        if (notas.isNotEmpty){
          for (var nota in notas){
            List<Map> etiquetas = await bd.rawQuery('SELECT idEtiqueta FROM nota_etiqueta WHERE (idNota = "${nota['id']}")');
            Nota note = Nota(id: nota['id'],
                     titulo: nota['titulo'],
                     contenido: nota['cuerpo'],
                     n_edit_date: DateTime.tryParse(nota['fechaModificacion']),
                     n_date: DateTime.tryParse(nota['fechaCreacion'])!,
                     estado: nota['estado'], 
                     idCarpeta: nota['idCarpeta'],
                     etiquetas: []);         
            if (etiquetas.isNotEmpty){
              for (var eti in etiquetas) {
                note.etiquetas!.add(etiqueta(id: eti['id'],nombre: '', idUsuario: ''));
              }
            }
            notes.add(note);  
          }
        }
        bd.close();
       return Right(notes);
    }catch(e){
      return Left(MyError(key: AppError.NotFound,message: e.toString()));
    }
  }

  @override
  Future<Either<MyError, List<Nota>>> getAllEliminatedNotes(String userId) {
    // TODO: implement getAllEliminatedNotes
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, List<Nota>>> getNotesByKeyword(String palabraClave, String idUsuario) {
    // TODO: implement getNotesByKeyword
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, String>> updateNota(Nota note) {
    // TODO: implement updateNota
    throw UnimplementedError();
  }
  
}