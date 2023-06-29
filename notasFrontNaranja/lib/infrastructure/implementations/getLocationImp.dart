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
      return Future.error('Los servicios de ubicación no está habilitados');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Los permisos de ubicación han sido rechazados');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Los permisos de ubicación han sido rechazados permanentemente, no podemos encontrar su ');
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
