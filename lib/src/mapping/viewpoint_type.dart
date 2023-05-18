part of arcgis_maps_flutter;

enum ViewpointType {
  /// A center point and scale.
  centerAndScale(0),

  /// A visible area.
  boundingGeometry(1),
  ;

  const ViewpointType(this.value);

  factory ViewpointType.fromValue(int value) {
    switch (value) {
      case 0:
        return ViewpointType.centerAndScale;
      case 1:
        return ViewpointType.boundingGeometry;
      default:
        throw ArgumentError.value(
            value, 'value', 'Invalid ViewpointType value.');
    }
  }

  final int value;
}
