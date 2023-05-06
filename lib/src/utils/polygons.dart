import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/utils/maps_object.dart';

/// Converts an [Iterable] of Polygon in a Map of MarkerId -> Marker.
Map<PolygonId, PolygonMarker> keyByPolygonId(Iterable<PolygonMarker> markers) {
  return keyByMapsObjectId<PolygonMarker>(markers).cast<PolygonId, PolygonMarker>();
}

/// Converts a Set of Markers into something serializable in JSON.
Object serializePolygonSet(Set<PolygonMarker> markers) {
  return serializeMapsObjectSet(markers);
}
