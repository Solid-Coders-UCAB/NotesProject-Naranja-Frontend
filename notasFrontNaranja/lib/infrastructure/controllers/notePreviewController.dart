import 'package:either_dart/either.dart';
import 'package:firstapp/application/DTOS/cmdGetAllTagsFromNote.dart';
import 'package:firstapp/domain/errores.dart';

import '../../application/Iservice.dart';
import '../../domain/nota.dart';


class notePreviewController {
  service<cmdGetAllTagsNote,cmdGetAllTagsNote> getAllTagsFromNote;

  notePreviewController({required this.getAllTagsFromNote});

  Future<Either<MyError,cmdGetAllTagsNote>>getAllTagsNote(Nota note) async {
    return await getAllTagsFromNote.execute(cmdGetAllTagsNote(nota: note));
  }
}