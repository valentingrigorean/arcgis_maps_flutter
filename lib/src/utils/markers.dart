
import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/utils/maps_object.dart';

/// Converts an [Iterable] of Markers in a Map of MarkerId -> Marker.
Map<MarkerId, Marker> keyByMarkerId(Iterable<Marker> markers) {
  return keyByMapsObjectId<Marker>(markers).cast<MarkerId, Marker>();
}

/// Converts a Set of Markers into something serializable in JSON.
Object serializeMarkerSet(Set<Symbol> markers) {
  return serializeMapsObjectSet(markers);
}