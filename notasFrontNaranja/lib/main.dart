import 'package:firebase_core/firebase_core.dart';
import 'package:firstapp/api/filebase_api.dart';

import 'package:flutter/material.dart';
import 'infrastructure/views/systemWidgets/inicio_sesion.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  //sqfliteFfiInit();
  //databaseFactory = databaseFactoryFfi;
  runApp(const App());
}
