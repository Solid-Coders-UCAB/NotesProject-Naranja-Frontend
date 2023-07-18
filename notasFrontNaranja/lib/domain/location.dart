import 'package:either_dart/either.dart';
import 'package:firstapp/domain/errores.dart';

class location {
  double? latitude;
  double? longitude;

  location({
    this.latitude,
    this.longitude,
  });

  static Either<MyError, location> create({latitude, longitude}) {
    return Right(location(latitude: latitude, longitude: longitude));
  }

  get getLatitude => latitude;
  get getLongitude => longitude;
}
