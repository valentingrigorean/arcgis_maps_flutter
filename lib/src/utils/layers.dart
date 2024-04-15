import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';

Map<String, Layer> keyByLayerId(Iterable<Layer> layers) {
  final Map<String, Layer> result = <String, Layer>{};
  for (final Layer layer in layers) {
    result[layer.layerId] = layer;
  }
  return result;
}

Object serializeLayerSet(Set<Layer> layers) {
  return layers.map((Layer layer) => layer.toJson()).toList();
}
