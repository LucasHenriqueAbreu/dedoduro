import 'package:geolocator/geolocator.dart';

class GeoLocationService {
  static String _toDegreesMinutesAndSeconds(num coordinate) {
    var absolute = coordinate.abs();
    var degrees = absolute.floor();
    var minutesNotTruncated = (absolute - degrees) * 60;
    var minutes = minutesNotTruncated.floor();
    var seconds = ((minutesNotTruncated - minutes) * 60).floor();

    return "$degrees° $minutes' $seconds''";
  }

  static String convertLatDMS(double lat) {
    var latitude = _toDegreesMinutesAndSeconds(lat);
    var latitudeCardinal = lat >= 0 ? "N" : "S";

    return '$latitudeCardinal $latitude';
  }

  static String convertLngDMS(double lng) {
    var longitude = _toDegreesMinutesAndSeconds(lng);
    var longitudeCardinal = lng >= 0 ? "L" : "O";

    return '$longitudeCardinal $longitude';
  }

  static Future<Position> getCurrentPosition() async {
    return await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
