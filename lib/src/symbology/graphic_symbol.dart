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

  static GraphicSymbol fromJson(Map<String, dynamic> json) => _JsonSymbol(json);
}

class _JsonSymbol extends GraphicSymbol {
  const _JsonSymbol(this._json);

  final Map<String, Object?> _json;

  @override
  String get type => 'json';

  @override
  Map<String, Object?> toJson() {
    final Map<String, Object?> json = super.toJson();
    json['data'] = jsonEncode(_json);
    return json;
  }

  @override
  List<Object?> get props => [_json];
}
