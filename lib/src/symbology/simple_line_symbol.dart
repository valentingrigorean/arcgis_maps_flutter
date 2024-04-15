part of '../../arcgis_maps_flutter.dart';

enum SimpleLineSymbolStyle {
  dash,
  dashDot,
  dashDotDot,
  dot,
  longDash,
  longDashDot,
  none,
  shortDash,
  shortDashDotDot,
  shortDashDot,
  shortDot,
  solid,
}

enum SimpleLineSymbolMarkerStyle {
  none,
  arrow,
}

enum SimpleLineSymbolMarkerPlacement {
  begin,
  beginAndEnd,
  end,
}

class SimpleLineSymbol extends LineSymbol {
  const SimpleLineSymbol({
    required this.style,
    required super.color,
    required super.width,
    required this.markerStyle,
    required this.markerPlacement,
    super.antialias,
  });

  final SimpleLineSymbolStyle style;

  final SimpleLineSymbolMarkerStyle markerStyle;

  final SimpleLineSymbolMarkerPlacement markerPlacement;

  @override
  String get type => 'simple-line';

  @override
  List<Object?> get props => [
        ...super.props,
        style,
        markerStyle,
        markerPlacement,
      ];

  @override
  Map<String, Object?> toJson() {
    final json = super.toJson();
    json['style'] = style.name;
    json['markerStyle'] = markerStyle.name;
    json['markerPlacement'] = markerPlacement.name;
    return json;
  }
}
