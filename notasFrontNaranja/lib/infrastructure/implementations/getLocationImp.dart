import 'package:either_dart/either.dart';
import 'package:firstapp/domain/location.dart';
import '../../domain/errores.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firstapp/application/getUserCurrentLocation.dart';

class GetLocationImp implements GetUserLocation {
  GetLocationImp();

  @override
  Future<Either<MyError, Location>> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return const Left(MyError(key: AppError.NotFound,message: 'los servicios de ubicacion no estan habilitados'));
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return const Left(MyError(key: AppError.NotFound,message: 'Los permisos de ubicación han sido rechazados'));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return const Left(MyError(key: AppError.NotFound,message: 'Los permisos de ubicación han sido rechazados'));
    }

    
    try {
      Position userPosition = await Geolocator.getCurrentPosition();

      Location userLocation = Location();

      userLocation.latitude = userPosition.latitude.toString();
      userLocation.longitude = userPosition.longitude.toString();

      return Right(userLocation);
    } catch (e) {
      return Left(MyError(key: AppError.NotFound, message: '$e'));
    }
  }
}
