part of '../../arcgis_maps_flutter.dart';

abstract class LineSymbol extends GraphicSymbol {
  const LineSymbol({
    this.antialias,
    required this.color,
    required this.width,
  });

  final bool? antialias;

  final Color color;

  final double width;

  @override
  List<Object?> get props => [antialias, color, width];

  @override
  Map<String, Object?> toJson() {
    final json = super.toJson();
    json.addIfNonNull('antialias', antialias);
    json.addIfNonNull('color', color.value);
    json.addIfNonNull('width', width);
    return json;
  }
}
