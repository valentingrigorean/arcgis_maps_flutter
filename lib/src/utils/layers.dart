import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/utils/maps_object.dart';

Map<String, Layer> keyByLayerId(Iterable<Layer> layers) {
  return keyByMapsObjectId<Layer>(layers);
}

Object serializeLayerSet(Set<Layer> layers) {
  return serializeMapsObjectSet(layers);
}
