part of arcgis_maps_flutter;


/// A `SymbolVisibilityFilter` defines the range of zoom levels at which a symbol is visible.
///
/// The `minZoom` and `maxZoom` properties represent the minimum and maximum zoom levels
/// at which the symbol is visible, respectively. The symbol is visible if the current zoom
/// level is within this range (inclusive).
///
/// Note that in this case, a higher zoom level means a more zoomed-in view, and a lower
/// zoom level means a more zoomed-out view.
///
/// You should ensure that `maxZoom` is greater than `minZoom`, otherwise an assertion error will be thrown.
@immutable
class SymbolVisibilityFilter {
  const SymbolVisibilityFilter({
    required this.minZoom,
    required this.maxZoom,
  }) : assert(maxZoom > minZoom, 'maxZoom should be greater then minZoom');

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
