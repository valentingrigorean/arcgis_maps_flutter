import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/maps_object.dart';

/// Converts an [Iterable] of [MapsObject]s in a Map of [MapObjectId] -> [MapObject].
Map<MapsObjectId<T>, T> keyByMapsObjectId<T extends MapsObject>(
    Iterable<T> objects) {
  return Map<MapsObjectId<T>, T>.fromEntries(objects.map((T object) =>
      MapEntry<MapsObjectId<T>, T>(
          object.mapsId as MapsObjectId<T>, object.clone())));
}

/// Converts a Set of [MapsObject]s into something serializable in JSON.
Object serializeMapsObjectSet(Set<MapsObject> mapsObjects) {
  return mapsObjects.map<Object>((MapsObject p) => p.toJson()).toList();
}

/// Converts a List of [Geometry]s into something serializable in JSON.
Object serializeGeometryList(List<Geometry> items) {
  return items.map<Object>((Geometry p) => p.toJson()).toList();
}

