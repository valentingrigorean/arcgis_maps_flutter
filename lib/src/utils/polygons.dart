import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/utils/maps_object.dart';

/// Converts an [Iterable] of Polygon in a Map of MarkerId -> Marker.
Map<PolygonId, Polygon> keyByPolygonId(Iterable<Polygon> markers) {
  return keyByMapsObjectId<Polygon>(markers).cast<PolygonId, Polygon>();
}

/// Converts a Set of Markers into something serializable in JSON.
Object serializePolygonSet(Set<Polygon> markers) {
  return serializeMapsObjectSet(markers);
}
