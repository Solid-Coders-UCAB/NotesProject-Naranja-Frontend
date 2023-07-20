import 'package:either_dart/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/location.dart';

abstract class GetUserLocation {
  Future<Either<MyError, location>> getCurrentLocation();
}

class GetUserCurrentLocationService implements service<void, location> {
  GetUserLocation loca;

  GetUserCurrentLocationService({
    required this.loca,
  });

  @override
  Future<Either<MyError, location>> execute(void params) async {
    Either<MyError, location> getLocationResponse =
        await loca.getCurrentLocation();
    if (getLocationResponse.isLeft) {
      return Left(getLocationResponse.left);
    }
    return Right(getLocationResponse.right);
  }
  
}
