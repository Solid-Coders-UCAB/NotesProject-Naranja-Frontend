// ignore_for_file: camel_case_types, file_names
import 'package:firstapp/application/connectionCheckerDecorator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class connectionCheckerImp implements connectionChecker{
  
  @override
  Future<bool> checkConnection() async {
    
    // Create customized instance which can be registered via dependency injection
  final InternetConnectionChecker customInstance = InternetConnectionChecker.createInstance(
    checkTimeout: const Duration(seconds: 1),
    checkInterval: const Duration(seconds: 1),
  );

      return await customInstance.hasConnection;  
  }

}