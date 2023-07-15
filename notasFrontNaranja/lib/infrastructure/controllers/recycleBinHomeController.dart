
// ignore_for_file: invalid_use_of_protected_member

import 'package:firstapp/application/DTOS/cmdDeleteNote.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/infrastructure/views/recycleBinWidgets.dart/recycleBinHome.dart';

import '../../application/DTOS/updateNoteParams.dart';
import '../../application/Iservice.dart';

class recycleBinHomeController {
  
  service<void, List<Nota>> getAllEliminatedNotesFromServerService;
  service<cmdDeleteNote,cmdDeleteNote> deleteNoteFromServerService;
  service<UpdateNoteParams,String> updateNoteFromServer;


  recycleBinHomeController({required this.getAllEliminatedNotesFromServerService, required this.deleteNoteFromServerService, required this.updateNoteFromServer});

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

  void deleteNote(recycleBinHomeState widget,Nota note) async {

    widget.setState(() {
      widget.loading = true;
    });
    
    var serviceResponse = await deleteNoteFromServerService.execute(cmdDeleteNote(nota: note));

     if (widget.mounted) {
      
      if (serviceResponse.isLeft){
        widget.showSystemMessage(serviceResponse.left.message);
      }else {
        getAllNotesFromServer(widget);
      }   

    }
  }

  void restaurarNote(recycleBinHomeState widget,Nota note) async {

    widget.setState(() {
      widget.loading = true;
    });
    
    var serviceResponse = await updateNoteFromServer.execute(
      UpdateNoteParams(estado: 'Guardada', idNota: note.id, contenido: note.getContenido, titulo: note.titulo, n_date: note.n_date, idCarpeta: note.idCarpeta)
    );

     if (widget.mounted) {
      
      if (serviceResponse.isLeft){
        widget.showSystemMessage(serviceResponse.left.message);
      }else {
        getAllNotesFromServer(widget);
      }   

    }
  }


}
