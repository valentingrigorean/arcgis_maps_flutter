part of '../../arcgis_maps_flutter.dart';

/// Marks a geographical location on the map.
///
/// A marker icon is drawn oriented against the device's screen rather than
/// the map's surface; that is, it will not necessarily change orientation
/// due to map rotations, tilting, or zooming.
@immutable
abstract class GraphicSymbol extends Equatable {
  const GraphicSymbol();

  String get type;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'type': type,
    };
  }

  static GraphicSymbol? fromJson(Map<String, dynamic> json) {
    return null;
  }
}
