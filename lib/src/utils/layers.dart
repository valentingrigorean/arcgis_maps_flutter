import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/utils/maps_object.dart';

Map<LayerId, Layer> keyByLayerId(Iterable<Layer> layers) {
  return keyByMapsObjectId<Layer>(layers).cast<LayerId, Layer>();
}

Object serializeLayerSet(Set<Layer> layers) {
  return serializeMapsObjectSet(layers);
}
