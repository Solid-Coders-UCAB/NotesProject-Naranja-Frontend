// ignore_for_file: camel_case_types, file_names

import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class imageToTextService {
  iaText? ia;

  imageToTextService(iaText i){ ia = i;}

  Future<Either<MyError,String>?> getConvertedText(File image) async {
    Either<MyError, String>? text = await ia?.getConvertedText(image);
      if (text!.isRight){
        return Right(text.right);
      }else{
        return Left(text.left);
      }
  }
  
}

abstract class iaText {
  Future<Either<MyError,String>> getConvertedText(File image);
}


class iaTextImp implements iaText {
    
    @override
      Future<Either<MyError, String>> getConvertedText(File image) async {
       try {

        final textDetector = GoogleMlKit.vision.textDetector();
        final recognisedText = await textDetector.processImage(InputImage.fromFile(image));
        String convertedText = '';
        await textDetector.close();
        for (TextBlock block in recognisedText.blocks) {
            for (TextLine line in block.lines) {
              convertedText = "$convertedText${line.text}\n";
          }
        }
          return Right(convertedText);
       } catch (e) {
          return Left(MyError(key: AppError.NotFound,message: '$e'));
       }     
    }
}