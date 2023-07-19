import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/application/getAllFoldersFromServerService.dart';
import 'package:firstapp/infrastructure/views/folderWidgets/folderHome.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/folder.dart';
class homeFolderController {

  service<void, List<folder>> getAllFoldersService;

  homeFolderController({required this.getAllFoldersService});

  getAllFolders(folderHomeState folderHome) async {

    folderHome.setLoadingState(true);
    
    var serviceResponse = await getAllFoldersService.execute(null);

      if (serviceResponse.isRight){
        folderHome.changeState(serviceResponse.right);
      }else{
        folderHome.showSystemMessage(serviceResponse.left.message);   
      }
         
  }
  
}