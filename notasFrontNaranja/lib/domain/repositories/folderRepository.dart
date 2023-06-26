import 'package:either_dart/either.dart';
import 'package:firstapp/domain/folder.dart';

import '../errores.dart';

abstract class folderRepository {
    
    Future<Either<MyError,String>> createFolder(folder folder);

    Future<Either<MyError,List<folder>>> getALLfolders();

}