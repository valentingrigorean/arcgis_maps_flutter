part of arcgis_maps_flutter;

enum SymbolAngleAlignment {
  map,
  screen,
}

abstract class MarkerSymbol extends Equatable {
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

  Map<String, Object?> toJson() {
    final Map<String, Object?> json = <String, Object?>{};
    if (angle != null) {
      json['angle'] = angle;
    }
    if (angleAlignment != null) {
      json['angleAlignment'] = angleAlignment!.name;
    }
    if (leaderOffset != null) {
      json['leaderOffset'] = <double>[leaderOffset!.dx, leaderOffset!.dy];
    }
    if (offset != null) {
      json['offset'] = <double>[offset!.dx, offset!.dy];
    }
    return json;
  }

  @override
  List<Object?> get props => [
        angle,
        angleAlignment,
        leaderOffset,
        offset,
      ];
}
