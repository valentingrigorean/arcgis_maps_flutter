part of '../../arcgis_maps_flutter.dart';

abstract class FillSymbol extends Symbol {
  const FillSymbol({
    required this.color,
    this.outline,
  });

  final Color color;

  final LineSymbol? outline;

  @override
  List<Object?> get props => [color, outline];

  @override
  Map<String, Object?> toJson() {
    final json = super.toJson();
    json['color'] = color.value;
    json.addIfNonNull('outline', outline?.toJson());
    return json;
  }
}
