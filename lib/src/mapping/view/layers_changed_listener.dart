part of arcgis_maps_flutter;

enum LayerType {
  operational,
  base,
  reference,
}

enum LayerChangeType {
  added,
  removed,
  unknown,
}

abstract class LayersChangedListener {
  void onLayersChanged(
    LayerType onLayer,
    LayerChangeType layerChange,
  );
}
