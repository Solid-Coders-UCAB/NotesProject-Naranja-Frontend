
// ignore_for_file: invalid_use_of_protected_member

import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/infrastructure/views/recycleBinWidgets.dart/recycleBinHome.dart';

import '../../application/Iservice.dart';

class recycleBinHomeController {
  
  service<void, List<Nota>> getAllEliminatedNotesFromServerService;

recycleBinHomeController({required this.getAllEliminatedNotesFromServerService});

   void getAllNotesFromServer(recycleBinHomeState widget) async {

    widget.setState(() {
      widget.loading = true;
    });

    
    var notas = await getAllEliminatedNotesFromServerService.execute(null);

     if (widget.mounted) {
      
      if (notas.isLeft){
        widget.showSystemMessage(notas.left.message);
      }else {
        widget.changeState(notas: notas.right, loading: false);
      }   

    }


  }
}
