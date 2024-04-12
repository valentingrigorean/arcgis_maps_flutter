part of '../../arcgis_maps_flutter.dart';

@immutable
class ElevationSourceId extends MapsObjectId<ElevationSource> {
  const ElevationSourceId(super.value);
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
