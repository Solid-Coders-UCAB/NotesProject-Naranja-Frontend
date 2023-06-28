// ignore_for_file: file_names, camel_case_types, invalid_use_of_protected_member
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/infrastructure/views/noteWidgets/home.dart';

class homeController {
  
  service getAllNotesFromServerService;

  homeController({required this.getAllNotesFromServerService});

   void getAllNotesFromServer(homeState widget) async {

    widget.loading = true;

    var notas = await getAllNotesFromServerService.execute(null);

     if (widget.mounted) {
      
      if (notas.isLeft){
        widget.setState(() {
          widget.loading = false;
        });
        widget.showSystemMessage(notas.left.message);
      }else {
        widget.setState(() {
          widget.notas = notas.right;
          widget.loading = false;
        });
      }   

    }


  }

  
 

}