import 'package:firstapp/application/DTOS/cmdCreateUser.dart';
import 'package:firstapp/application/createNoteInServerService.dart';
import 'package:firstapp/application/createUserService.dart';
import 'package:firstapp/controllerFactory.dart';
import 'package:firstapp/application/DTOS/createNoteParams.dart';
import 'package:firstapp/domain/user.dart';
import 'package:firstapp/infrastructure/implementations/repositories/HTTPuserRepository.dart';
import 'package:firstapp/infrastructure/implementations/repositories/localUserRepository.dart';
import 'package:flutter/material.dart';
import 'infrastructure/views/systemWidgets/inicio_sesion.dart';
import 'infrastructure/views/systemWidgets/pruebaImageToText.dart';
import 'infrastructure/views/noteWidgets/drawing_room_screen.dart';
import 'infrastructure/views/noteWidgets/speech_to_text_prueba.dart';

void main() {
  //sqfliteFfiInit();
  //databaseFactory = databaseFactoryFfi;
  runApp(const App());
}
