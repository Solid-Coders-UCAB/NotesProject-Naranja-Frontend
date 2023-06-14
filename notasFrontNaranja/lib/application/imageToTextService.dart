// ignore_for_file: camel_case_types, file_names

import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:firstapp/domain/errores.dart';

class imageToTextService {
  iaText ia;

  imageToTextService( { required this.ia} );

  Future<Either<MyError,String>> getConvertedText(File image) async {
    Either<MyError, String> iaResponse = await ia.getConvertedText(image);
      
      if (iaResponse.isRight){
        return Right(iaResponse.right);
      }else{
        return Left(iaResponse.left);
      }
  }
  
}

abstract class iaText {
  Future<Either<MyError,String>> getConvertedText(File image);
}
