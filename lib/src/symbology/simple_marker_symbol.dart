part of '../../arcgis_maps_flutter.dart';


enum SimpleMarkerSymbolStyle {
  circle,
  cross,
  diamond,
  square,
  triangle,
  x,
}


class SimpleMarkerSymbol extends MarkerSymbol {
  const SimpleMarkerSymbol({
    this.style = SimpleMarkerSymbolStyle.circle,
    this.color = const Color(0xFF000000),
    this.size = 8,
    super.angle,
    super.angleAlignment,
    super.leaderOffset,
    super.offset,
  });

  final SimpleMarkerSymbolStyle style;
  final Color color;
  final double size;

  @override
  String get type => 'simple-marker';

  @override
  List<Object?> get props =>
      [
        ...super.props,
        style,
        color,
        size,
      ];

  @override
  Map<String, Object?> toJson() {
    final Map<String, Object?> json = super.toJson();
    json['style'] = style.name;
    json['color'] = color.value;
    json['size'] = size;
    return json;
  }
}