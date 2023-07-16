import 'package:either_dart/either.dart';
import 'package:firstapp/domain/folder.dart';

import '../errores.dart';

abstract class folderRepository {
    
    Future<Either<MyError, String>> createFolder(folder folder);
    Future<Either<MyError, String>> updateFolder(folder folder);
    Future<Either<MyError, List<folder>>> getALLfolders(String userId);
    Future<Either<MyError, folder>> getDefaultFolder(String userId);
    Future<Either<MyError, String>> deleteCarpeta(String idCarpeta);
}