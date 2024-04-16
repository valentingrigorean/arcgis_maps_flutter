part of '../../arcgis_maps_flutter.dart';

enum GeometryType {
  unknown,
  point,
  envelope,
  polyline,
  polygon,
  multipoint;

  factory GeometryType.fromValue(String value) {
    switch (value) {
      case 'point':
        return GeometryType.point;
      case 'envelope':
        return GeometryType.envelope;
      case 'polyline':
        return GeometryType.polyline;
      case 'polygon':
        return GeometryType.polygon;
      case 'multipoint':
        return GeometryType.multipoint;
      default:
        return GeometryType.unknown;
    }
  }
}
