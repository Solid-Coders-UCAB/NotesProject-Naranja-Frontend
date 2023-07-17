// ignore_for_file: file_names, camel_case_types, invalid_use_of_protected_member
import 'package:firstapp/infrastructure/views/folderWidgets/notas_en_carpeta.dart';
import 'package:firstapp/application/getNotesByFolderService.dart';
import 'package:firstapp/application/DTOS/getNotesByFolderDTO.dart';

class notasEnCarpetaController {
  
  getNotesByFolderService notesByFolderService;

  notasEnCarpetaController({required this.notesByFolderService});

   void getNotesByFolder(NotasCarpetaState widget, String idCarpeta) async {

    widget.loading = true;

    var notas = await notesByFolderService.execute(getNotesByFolderDTO(idCarpeta: idCarpeta));

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