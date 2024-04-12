part of '../../arcgis_maps_flutter.dart';

enum SymbolAngleAlignment {
  map,
  screen,
}

abstract class MarkerSymbol extends Symbol {
  final double? angle;

  final SymbolAngleAlignment? angleAlignment;

  final Offset? leaderOffset;

  final Offset? offset;

  const MarkerSymbol({
    this.angle,
    this.angleAlignment,
    this.leaderOffset,
    this.offset,
  });

  @override
  List<Object?> get props => [
    angle,
    angleAlignment,
    leaderOffset,
    offset,
  ];

  @override
  Map<String, Object?> toJson() {
    final Map<String, Object?> json = super.toJson();
    json.addIfPresent('angle', angle);
    json.addIfPresent('angleAlignment', angleAlignment?.name);
    if (leaderOffset != null) {
      json['leaderOffset'] = <double>[leaderOffset!.dx, leaderOffset!.dy];
    }
    if (offset != null) {
      json['offset'] = <double>[offset!.dx, offset!.dy];
    }
    return json;
  }
}
