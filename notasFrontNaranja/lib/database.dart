import 'package:either_dart/either.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';


class database {

String patch = '';  

static Future<Database> getDatabase() async {
  var databasesPath = await getDatabasesPath();
  String p = join(databasesPath, 'notesApp.db');
  print(p);

  return await openDatabase(p, version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE User (id TEXT PRIMARY KEY, name TEXT)');
      await db.execute('''
            CREATE TABLE nota (
            id TEXT PRIMARY KEY,
            savedInServer INT NOT NULL,
            fechaModificacion TEXT NOT NULL,
            fechaCreacion TEXT NOT NULL,
            estado TEXT NOT NULL,
            titulo TEXT NOT NULL,
            cuerpo TEXT,
            longitud REAL,
            latitud REAL,
            idCarpeta TEXT NOT NULL,
            FOREIGN KEY (idCarpeta) REFERENCES carpeta(id) ON DELETE CASCADE
            )
      ''');
      await db.execute('''
            CREATE TABLE carpeta (
            id TEXT PRIMARY KEY,
            savedInServer INT NOT NULL,
            predeterminada INT NOT NULL,
            nombre TEXT NOT NULL
            )
      ''');
      await db.execute('''
            CREATE TABLE etiqueta (
            id TEXT PRIMARY KEY,
            savedInServer INT NOT NULL,
            nombre TEXT NOT NULL
            )
      ''');
      await db.execute('''
            CREATE TABLE nota_etiqueta (
            idEtiqueta TEXT NOT NULL,
            idNota TEXT NOT NULL,
            savedInServer INT NOT NULL,
            PRIMARY KEY (idEtiqueta, idNota)
            FOREIGN KEY (idEtiqueta) REFERENCES etiqueta(id) ON DELETE CASCADE,
            FOREIGN KEY (idNota) REFERENCES nota(id) ON DELETE CASCADE
            )
      ''');
      await db.execute('''
            INSERT INTO carpeta(id,savedInServer,predeterminada,nombre) VALUES ("1",1,1,"carpeta predeterminada local")
      ''');        
      }      
    );
  }

  static Future<Either<MyError,dynamic>> deleteNoteTable()async {
    var bd = await getDatabase();
    try {
      await bd.transaction((txn) async {
        await txn.execute('DELETE FROM nota');
      });
    } catch (e) {
      await bd.close();
      return Left(MyError(key: AppError.NotFound, message: e.toString()));
    }
    await bd.close();
    return const Right("");
  }
    static Future<Either<MyError,dynamic>> deleteCarpetaTable()async {
    var bd = await getDatabase();
    try {
      await bd.transaction((txn) async {
        await txn.execute('DELETE FROM carpeta');
      });
    } catch (e) {
      await bd.close();
      return Left(MyError(key: AppError.NotFound, message: e.toString()));
    }
    await bd.close();
    return const Right("");
  }
   
}