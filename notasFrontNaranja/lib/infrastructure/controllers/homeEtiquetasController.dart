import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/etiqueta.dart';
import 'package:firstapp/infrastructure/views/etiquetasWidgets/etiquetasHome.dart';

class homeEtiquetasController {

  service<void,List<etiqueta>> getAllEtiquetasService;

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