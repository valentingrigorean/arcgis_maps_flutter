part of arcgis_maps_flutter;

@immutable
class LayerId extends MapsObjectId<Layer> {
  const LayerId(String value) : super(value);
}

abstract class Layer extends MapsObject<Layer> {
  const Layer();
}
