import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import '../../application/imageToTextService.dart';
import '../../domain/errores.dart';

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