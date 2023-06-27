import 'package:either_dart/either.dart';
import 'package:firstapp/application/getAllFoldersFromServerService.dart';
import 'package:firstapp/infrastructure/views/folderWidgets/folderHome.dart';

import '../../application/Iservice.dart';
import '../../domain/folder.dart';

class homeFolderController {

  getAllFoldersFromServerService getAllFoldersService;

  homeFolderController({required this.getAllFoldersService});

  getAllFolders(folderHomeState folderHome) async {

    folderHome.setLoadingState(true);
    
    var serviceResponse = await getAllFoldersService.execute(null);

      if (serviceResponse.isRight){
        folderHome.changeState(serviceResponse.right);
      }

      if (serviceResponse.isLeft){
        folderHome.showSystemMessage(serviceResponse.left.message);
      }
         
  }
  
}