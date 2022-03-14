import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/utils/maps_object.dart';

/// Converts an [Iterable] of Polylines in a Map of PolylineId -> Polyline.
Map<PolylineId, Polyline> keyByPolylineId(Iterable<Polyline> polylines) {
  return keyByMapsObjectId<Polyline>(polylines).cast<PolylineId, Polyline>();
}

/// Converts a Set of Polylines into something serializable in JSON.
Object serializePolylineSet(Set<Polyline> polylines) {
  return serializeMapsObjectSet(polylines);
}