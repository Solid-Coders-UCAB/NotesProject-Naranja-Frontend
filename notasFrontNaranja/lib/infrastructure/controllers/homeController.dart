import 'package:either_dart/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/application/getAllNotesFromServerService.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/infrastructure/views/home/home.dart';

import '../../domain/nota.dart';

class homeController {
  
  service getAllNotesFromServerService;

  homeController({required this.getAllNotesFromServerService});

  Future<Either<MyError,List<Nota>>> getAllNotesFromServer(homeState widget) async {
    
    var notas = await getAllNotesFromServerService.execute(null);

    
    return Right(notas.right);
      

  }

  
 

}