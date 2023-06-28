// ignore_for_file: file_names, camel_case_types, invalid_use_of_protected_member

import 'package:either_dart/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/infrastructure/views/home/home.dart';


class homeController {
  
  service getAllNotesFromServerService;

  homeController({required this.getAllNotesFromServerService});

   void getAllNotesFromServer(homeState widget) async {
    
    var notas = await getAllNotesFromServerService.execute(null);

      if (notas.isLeft){
        widget.showSystemMessage(notas.left.message);
      }else {
        widget.setState(() {
          widget.notas = notas.right;
          widget.loading = false;
        });
      }
      
  }

  
 

}