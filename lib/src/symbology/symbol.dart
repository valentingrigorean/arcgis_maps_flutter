part of arcgis_maps_flutter;

/// Uniquely identifies a [Marker] among [ArcgisMapView] markers.
///
/// This does not have to be globally unique, only unique among the list.
@immutable
class SymbolId<T extends Symbol> extends MapsObjectId<T> {
  /// Creates an immutable identifier for a [Marker].
  const SymbolId(String value) : super(value);
}

/// Marks a geographical location on the map.
///
/// A marker icon is drawn oriented against the device's screen rather than
/// the map's surface; that is, it will not necessarily change orientation
/// due to map rotations, tilting, or zooming.
@immutable
abstract class Symbol implements MapsObject {
  const Symbol({
    required this.symbolId,
  });

  /// Uniquely identifies a [Symbol].
  final SymbolId symbolId;

  @override
  SymbolId get mapsId => symbolId;
}
