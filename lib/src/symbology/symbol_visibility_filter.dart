part of arcgis_maps_flutter;

@immutable
class SymbolVisibilityFilter {
  const SymbolVisibilityFilter({
    required this.minZoom,
    required this.maxZoom,
  }) : assert(minZoom > maxZoom, 'minZoom should be greater then maxZoom');

  final double minZoom;
  final double maxZoom;

  Object toJson() {
    final Map<String, Object> json = {};

    json['minZoom'] = minZoom;
    json['maxZoom'] = maxZoom;

    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SymbolVisibilityFilter &&
          runtimeType == other.runtimeType &&
          minZoom == other.minZoom &&
          maxZoom == other.maxZoom;

  @override
  int get hashCode => minZoom.hashCode ^ maxZoom.hashCode;
}
