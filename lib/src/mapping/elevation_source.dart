part of arcgis_maps_flutter;

@immutable
class ElevationSourceId extends MapsObjectId<ElevationSource> {
  const ElevationSourceId(String value) : super(value);
}

abstract class ElevationSource implements MapsObject {
  @override
  clone() {
    throw UnimplementedError();
  }

  @override
  MapsObjectId get mapsId => throw UnimplementedError();

  @override
  Object toJson() {
    throw UnimplementedError();
  }
}
