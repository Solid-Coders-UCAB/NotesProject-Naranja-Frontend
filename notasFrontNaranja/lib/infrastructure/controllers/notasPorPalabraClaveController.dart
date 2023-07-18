// ignore_for_file: file_names, camel_case_types, invalid_use_of_protected_member
import 'package:firstapp/application/getNotesByKeywordService.dart';
import 'package:firstapp/application/DTOS/getNotesByKeywordDTO.dart';
import 'package:firstapp/infrastructure/views/filterWidgets/searchNotaDelegate.dart';

class notasPorPalabraClaveController {
  
  getNotesByKeywordService notesByKeywordService;

  notasPorPalabraClaveController({required this.notesByKeywordService});

void getNotesByKeyword(NotasCarpetaState widget, String palabraClave) async {


    var notas = await notesByKeywordService.execute(getNotesByKeywordDTO(palabraClave: palabraClave));
      
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
