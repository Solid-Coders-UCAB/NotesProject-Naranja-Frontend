import 'package:either_dart/either.dart';
import 'package:firstapp/domain/errores.dart';

class Location {
  String? latitude;
  String? longitude;

  Location({
    this.latitude,
    this.longitude,
  });

  static Either<MyError, Location> create({latitude, longitude}) {
    return Right(Location(latitude: latitude, longitude: longitude));
  }

  get getLatitude => latitude;
  get getLongitude => longitude;
}
