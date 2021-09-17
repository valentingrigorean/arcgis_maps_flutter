part of arcgis_maps_flutter;

@immutable
class WmsLayerDimension extends Equatable {
  const WmsLayerDimension({
    required this.name,
    required this.units,
    this.unitSymbol,
    this.defaultValue,
    this.multipleValues = false,
    this.nearestValue = false,
    this.current = false,
    required this.extent,
  });

  /// Stating name of dimensional axis.
  final String name;

  /// Indicating units of dimensional axis.
  final String units;

  /// Specifying symbol.
  final String? unitSymbol;

  /// Indicating default value that will be used if GetMap request does not specify
  /// a value. If attribute is absent, then shall respond with a service exception if request
  /// does not include a value for that dimension.
  final String? defaultValue;

  /// Boolean indicating whether multiple values of the dimension may be
  /// requested. [false] = single values only; [true] = multiple values permitted.
  /// Default = [false].
  final bool multipleValues;

  /// Boolean indicating whether nearest value of the dimension will be returned in
  /// response to a request for a nearby value. [false] = request value(s) must
  /// correspond exactly to declared extent value(s); [true] = request values may be
  /// approximate. Default = [false].
  final bool nearestValue;

  /// Boolean valid only for temporal extents (i.e. if attribute name="time"). This
  /// attribute, if it either [true], indicates (a) that temporal data are normally kept
  /// current and (b) that the request parameter TIME may include the keyword “current”
  /// instead of an ending value (see C.4.1). Default = [false].
  final bool current;

  /// Text content indicating available value(s) for dimension.
  final String extent;

  @override
  List<Object?> get props => [
        name,
        units,
        unitSymbol,
        defaultValue,
        multipleValues,
        nearestValue,
        current,
        extent
      ];
}


