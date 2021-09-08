import 'dart:math';

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';

class Utils {
  static Random _random = new Random();

  Utils._();

  static Point getRandomLocation(Point point, int radius) {
    double x0 = point.latitude;
    double y0 = point.longitude;

    double radiusInDegrees = radius / 111000;

    double u = _random.nextDouble();
    double v = _random.nextDouble();
    double w = radiusInDegrees * sqrt(u);
    double t = 2 * pi * v;
    double x = w * cos(t);
    double y = w * sin(t) * 1.75;

    // Adjust the x-coordinate for the shrinking of the east-west distances
    double new_x = x / sin(y0);

    double foundLatitude = new_x + x0;
    double foundLongitude = y + y0;

    return Point.fromLatLng(latitude: foundLatitude, longitude: foundLongitude);
  }
}
