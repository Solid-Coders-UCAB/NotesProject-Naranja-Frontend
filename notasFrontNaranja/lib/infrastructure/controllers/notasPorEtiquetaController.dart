// ignore_for_file: file_names, camel_case_types, invalid_use_of_protected_member
import 'package:firstapp/infrastructure/views/etiquetasWidgets/notasPorEtiqueta.dart';
import 'package:firstapp/application/getNotesByEtiquetaService.dart';
import 'package:firstapp/application/DTOS/getNotesByEtiquetaDTO.dart';

class notasPorEtiquetaController {
  
  getNotesByEtiquetaService notesByEtiquetaService;

  notasPorEtiquetaController({required this.notesByEtiquetaService});

   void getNotesByEtiqueta(NotasEtiquetaState widget, String idEtiqueta) async {

    widget.loading = true;

    var notas = await notesByEtiquetaService.execute(getNotesByEtiquetaDTO(idEtiqueta: idEtiqueta));

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