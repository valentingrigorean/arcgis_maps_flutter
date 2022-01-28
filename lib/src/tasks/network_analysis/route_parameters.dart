part of arcgis_maps_flutter;

@immutable
class RouteParameters {
  const RouteParameters({
    this.accumulateAttributeNames = const [],
    this.directionsDistanceUnits = UnitSystem.metric,
    this.directionsLanguage = '',
    this.directionsStyle = DirectionsStyle.desktop,
    this.findBestSequence = false,
    this.startTime,
    this.outputSpatialReference,
    this.preserveFirstStop = false,
    this.preserveLastStop = false,
    this.returnDirections = false,
    this.returnPointBarriers = false,
    this.returnPolygonBarriers = false,
    this.returnPolylineBarriers = false,
    this.returnRoutes = true,
    this.returnStops = false,
    this.routeShapeType = RouteShapeType.trueShapeWithMeasures,
    this.travelMode,
  });

  factory RouteParameters.fromJson(Map<String, dynamic> json) {
    return RouteParameters(
      accumulateAttributeNames:
          json['accumulateAttributeNames'] as List<String>,
      directionsDistanceUnits:
          UnitSystem.values[json['directionsDistanceUnits'] as int],
      directionsLanguage: json['directionsLanguage'] as String,
      directionsStyle: DirectionsStyle.values[json['directionsStyle'] as int],
      findBestSequence: json['findBestSequence'] as bool,
      startTime: parseDateTimeSafeNullable(json['startTime']),
      outputSpatialReference: json['outputSpatialReference'] != null
          ? SpatialReference.fromJson(
              json['outputSpatialReference'] as Map<String, dynamic>)
          : null,
      preserveFirstStop: json['preserveFirstStop'] as bool,
      preserveLastStop: json['preserveLastStop'] as bool,
      returnDirections: json['returnDirections'] as bool,
      returnPointBarriers: json['returnPointBarriers'] as bool,
      returnPolygonBarriers: json['returnPolygonBarriers'] as bool,
      returnPolylineBarriers: json['returnPolylineBarriers'] as bool,
      returnRoutes: json['returnRoutes'] as bool,
      returnStops: json['returnStops'] as bool,
      routeShapeType: RouteShapeType.values[json['routeShapeType'] as int],
      travelMode: json['travelMode'] != null
          ? TravelMode.fromJson(json['travelMode'] as Map<String, dynamic>)
          : null,
    );
  }

  /// A list of network attributes to be accumulated and returned as part
  /// of the route. You might want to perform the analysis using a
  /// distance-based impedance attribute and accumulate a time-based cost
  /// attribute. Available attributes are specified by
  /// [RouteTaskInfo.accumulateAttributeNames]. These attributes represent
  /// costs such as Drive Time, Distance,Toll expenses, etc.
  final List<String> accumulateAttributeNames;

  /// The linear units to use while providing distances for
  /// turn-by-turn directions.
  final UnitSystem directionsDistanceUnits;

  /// The language used when computing directions. For example, en, fr, pt-BR,
  /// zh-Hans, etc. The list of languages supported is available
  /// in [RouteTaskInfo.supportedLanguages].
  final String directionsLanguage;

  /// The style to use for providing directions.
  final DirectionsStyle directionsStyle;

  /// Specifies whether or not to optimize the order of the stops in the route.
  final bool findBestSequence;

  /// The time the route begins. If not specified, defaults to the time
  /// the task is executed.
  final DateTime? startTime;

  /// The spatial reference in which the result geometries should be returned.
  /// If null, the results will be returned in the spatial reference specified
  /// by [RouteTaskInfo.outputSpatialReference].
  final SpatialReference? outputSpatialReference;

  /// if true, keeps the last stop fixed in the sequence even when
  /// [findBestSequence] is enabled.Only applicable if [findBestSequence] is enabled.
  final bool preserveFirstStop;

  /// If true, keeps the last stop fixed in the sequence even when [findBestSequence] is enabled.
  /// Only applicable if [findBestSequence] is enabled.
  final bool preserveLastStop;

  /// Specifies whether to return turn-by-turn directions in the result
  /// @c AGSRoute#directionManeuvers.
  final bool returnDirections;

  /// Specifies whether to return the point barriers used while computing the route
  /// in the result @c AGSRouteResult#pointBarriers
  final bool returnPointBarriers;

  /// Specifies whether to return the polyline barriers used while computing
  /// the route in the result @c AGSRouteResult#polylineBarriers
  final bool returnPolygonBarriers;

  /// Specifies whether to return the polyline barriers used while computing
  /// the route in the result @c AGSRouteResult#polylineBarriers
  final bool returnPolylineBarriers;

  /// Specifies whether to return routes in the result @c AGSRouteResult#routes
  final bool returnRoutes;

  /// Specifies whether to return stops along each route in the result @c AGSRoute#stops
  final bool returnStops;

  /// Specifies the type of route geometry to return in the result @c AGSRoute#routeGeometry
  final RouteShapeType routeShapeType;

  /// Specifies the travel mode to use when computing the routes
  final TravelMode? travelMode;

  Object toJson() {
    var json = <String, dynamic>{};
    json['accumulateAttributeNames'] = accumulateAttributeNames;
    json['directionsDistanceUnits'] = directionsDistanceUnits;
    json['directionsLanguage'] = directionsLanguage;
    json['directionsStyle'] = directionsStyle;
    json['findBestSequence'] = findBestSequence;
    json['startTime'] = startTime;
    json['outputSpatialReference'] = outputSpatialReference;
    json['preserveFirstStop'] = preserveFirstStop;
    json['preserveLastStop'] = preserveLastStop;
    json['returnDirections'] = returnDirections;
    json['returnPointBarriers'] = returnPointBarriers;
    json['returnPolygonBarriers'] = returnPolygonBarriers;
    json['returnPolylineBarriers'] = returnPolylineBarriers;
    json['returnRoutes'] = returnRoutes;
    json['returnStops'] = returnStops;
    json['routeShapeType'] = routeShapeType;
    if (travelMode != null) json['travelMode'] = travelMode!.toJson();
    return json;
  }
}
