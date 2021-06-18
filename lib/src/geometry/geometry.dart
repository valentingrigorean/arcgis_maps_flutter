part of arcgis_maps_flutter;

abstract class Geometry {
  Object toJson();

  static Geometry? fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return null;
    }
    if (json.containsKey('xmax')) {
      return Envelope.fromJson(json);
    }
    if (json.containsKey('paths')) {
      return AGSPolyline.fromJson(json);
    }
    return Point.fromJson(json);
  }
}
