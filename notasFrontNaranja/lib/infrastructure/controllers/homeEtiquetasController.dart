import 'package:firstapp/application/getAllFoldersFromServerService.dart';
import 'package:firstapp/infrastructure/views/etiquetasWidgets/etiquetasHome.dart';
import 'package:firstapp/application/getAllEtiquetasFromServerService.dart';
class homeEtiquetasController {

  getAllEtiquetasFromServerService getAllEtiquetasService;

  homeEtiquetasController({required this.getAllEtiquetasService});

  getAllLabels(etiquetasHomeState etiquetasHome) async {

    etiquetasHome.setLoadingState(true);
    
    var serviceResponse = await getAllEtiquetasService.execute(null);

      if (serviceResponse.isRight){
        etiquetasHome.changeState(serviceResponse.right);
      }else{
        etiquetasHome.showSystemMessage(serviceResponse.left.message);   
      }

      if (serviceResponse.isLeft){
        etiquetasHome.showSystemMessage(serviceResponse.left.message);
      }
         
  }
  
}