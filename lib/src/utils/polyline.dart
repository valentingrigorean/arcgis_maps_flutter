import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/utils/maps_object.dart';

/// Converts an [Iterable] of Polylines in a Map of PolylineId -> Polyline.
Map<PolylineId, PolylineMarker> keyByPolylineId(Iterable<PolylineMarker> polylines) {
  return keyByMapsObjectId<PolylineMarker>(polylines).cast<PolylineId, PolylineMarker>();
}

/// Converts a Set of Polylines into something serializable in JSON.
Object serializePolylineSet(Set<PolylineMarker> polylines) {
  return serializeMapsObjectSet(polylines);
}