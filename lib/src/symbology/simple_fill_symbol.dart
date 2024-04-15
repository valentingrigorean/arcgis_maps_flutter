part of '../../arcgis_maps_flutter.dart';

enum SimpleFillSymbolStyle {
  backwardDiagonal,
  cross,
  diagonalCross,
  forwardDiagonal,
  horizontal,
  none,
  solid,
  vertical,
}

class SimpleFillSymbol extends FillSymbol {
  const SimpleFillSymbol({
    required this.style,
    required super.color,
    super.outline,
  });

  final SimpleFillSymbolStyle style;

  @override
  String get type => 'simple-fill';


  @override
  List<Object?> get props => [...super.props, style];

  @override
  Map<String, Object?> toJson() {
    final json = super.toJson();
    json['style'] = style.name;
    return json;
  }
}
