part of arcgis_maps_flutter;

@immutable
class RouteTaskInfo {
  const RouteTaskInfo._({
    required this.accumulateAttributeNames,
    required this.costAttributes,
    required this.defaultTravelModeName,
    required this.directionsDistanceUnits,
    required this.directionsLanguage,
    required this.directionsStyle,
    required this.findBestSequence,
    required this.maxLocatingDistance,
    required this.startTime,
    required this.networkName,
    required this.outputSpatialReference,
    required this.preserveFirstStop,
    required this.preserveLastStop,
    required this.restrictionAttributes,
    required this.routeShapeType,
    required this.supportedLanguages,
    required this.supportedRestrictionUsageParameterValues,
    required this.directionsSupport,
    required this.travelModes,
    required this.supportsRerouting,
  });

  factory RouteTaskInfo.fromJson(Map<String, dynamic> json) {
    final accumulateAttributeNames =
        json['accumulateAttributeNames'] as List<String>;
    final costAttributes = (json['costAttributes'] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, CostAttribute.fromJson(json)));

    final restrictionAttributes =
        (json['restrictionAttributes'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, RestrictionAttribute.fromJson(json)));

    return RouteTaskInfo._(
        accumulateAttributeNames: accumulateAttributeNames,
        costAttributes: costAttributes,
        defaultTravelModeName: json['defaultTravelModeName'] as String,
        directionsDistanceUnits: json.containsKey('directionsDistanceUnits')
            ? UnitSystem.values[json['directionsDistanceUnits']]
            : UnitSystem.unknown,
        directionsLanguage: json['directionsLanguage'] as String,
        directionsStyle: DirectionsStyle.values[json['directionsStyle']],
        findBestSequence: json['findBestSequence'] as bool,
        maxLocatingDistance: json['maxLocatingDistance'] as double,
        startTime: parseDateTimeSafeNullable(json['startTime']),
        networkName: json['networkName'] as String,
        outputSpatialReference: json['outputSpatialReference'] == null
            ? null
            : SpatialReference.fromJson(
                json['outputSpatialReference'] as Map<String, dynamic>),
        preserveFirstStop: json['preserveFirstStop'] as bool,
        preserveLastStop: json['preserveLastStop'] as bool,
        restrictionAttributes: restrictionAttributes,
        routeShapeType: RouteShapeType.values[json['routeShapeType']],
        supportedLanguages: json['supportedLanguages'] as List<String>,
        supportedRestrictionUsageParameterValues:
            json['supportedRestrictionUsageParameterValues'] as List<String>,
        directionsSupport:
            NetworkDirectionsSupport.values[json['directionsSupport']],
        travelModes: TravelMode.fromJsonList(json['travelModes']),
        supportsRerouting: json['supportsRerouting'] as bool);
  }

  /// A list of network attributes that can be accumulated and returned as
  /// part of the route. You might want to perform the analysis using a
  /// distance-based impedance attribute and accumulate a time-based
  /// cost attribute. The results of this kind of analysis are based on distance,
  /// but they also specify how long it would take to reach a portion
  /// of the service area.
  final List<String> accumulateAttributeNames;

  /// A list of cost attributes that can be used as a travel mode impedance
  /// (@c AGSTravelMode#impedanceAttributeName) to optimize the route.
  /// The key in the dictionary represents the name of the cost attribute.
  final Map<String, CostAttribute>? costAttributes;

  /// The name of travel mode that is used by default.
  final String defaultTravelModeName;

  /// The linear units used while providing distances for turn-by-turn directions.
  final UnitSystem directionsDistanceUnits;

  /// The language used when computing directions. For example, en, fr, pt-BR, zh-Hans etc.
  final String directionsLanguage;

  /// The style used for providing directions.
  final DirectionsStyle directionsStyle;

  /// Specifies whether or not to optimize the order of the stops in the route.
  final bool findBestSequence;

  /// Maximum locating distance is the furthest distance in meters that
  /// is searched when locating or relocating a point onto the network.
  /// The search looks for suitable edges or junctions and snaps the
  /// point to the nearest one.If a suitable location isn't found within the
  /// maximum locating distance, the object is marked as unlocated.
  final double maxLocatingDistance;

  /// The time the route begins. If not specified, defaults to the time the task is executed.
  final DateTime? startTime;

  /// Name of the underlying transportation network dataset.
  final String networkName;

  /// The spatial reference in which the result geometries are returned,
  /// unless the [RouteParameters.outputSpatialReference] property is specified.
  final SpatialReference? outputSpatialReference;

  /// If true, keeps the first stop fixed in the sequence even when
  /// [findBestSequence] is enabled.
  /// Only applicable if [findBestSequence] is enabled.
  final bool preserveFirstStop;

  /// If @c YES, keeps the last stop fixed in the sequence even when
  /// the [findBestSequence] property is enabled.
  /// Only applicable if the [findBestSequence] property is enabled.
  final bool preserveLastStop;

  /// The list of supported restrictions for constraining the route.
  /// The key in the dictionary represents the name of the restriction attribute.
  final Map<String, RestrictionAttribute>? restrictionAttributes;

  /// Specifies the type of route geometry to return in the result @c AGSRoute#routeGeometry.
  final RouteShapeType routeShapeType;

  /// The list of languages supported for generating turn-by-turn driving directions.
  final List<String> supportedLanguages;

  /// The list of supported restriction parameter values.
  final List<String> supportedRestrictionUsageParameterValues;

  /// Whether the underlying network dataset supports the returning of directions.
  final NetworkDirectionsSupport directionsSupport;

  /// Specifies the available travel modes that can be used to customize the route.
  final List<TravelMode> travelModes;

  /// Indicates whether the network analyst service or dataset supports rerouting.
  /// If the property doesn't exist on a service, it will default to [false]. For local data value will be [true].
  final bool supportsRerouting;
}
