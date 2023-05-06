part of arcgis_maps_flutter;

@immutable
class Route {
  const Route._({
    required this.directionManeuvers,
    required this.startTime,
    required this.startTimeShift,
    required this.endTime,
    required this.endTimeShift,
    required this.totalLength,
    required this.routeGeometry,
    required this.stops,
    required this.routeName,
    required this.totalTime,
    required this.travelTime,
    required this.violationTime,
    required this.waitTime,
  });

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route._(
      directionManeuvers:
          DirectionManeuver.fromJsonList(json['directionManeuvers']),
      startTime: parseDateTimeSafeNullable(json['startTime']),
      startTimeShift: json['startTimeShift'] as double,
      endTime: parseDateTimeSafeNullable(json['endTime']),
      endTimeShift: json['endTimeShift'] as double,
      totalLength: json['totalLength'] as double,
      routeGeometry: Geometry.fromJson(json['routeGeometry']) as Polyline?,
      routeName: json['routeName'] as String,
      totalTime: json['totalTime'] as double,
      travelTime: json['travelTime'] as double,
      violationTime: json['violationTime'] as double,
      waitTime: json['waitTime'] as double,
      stops: Stop.fromJsonList(json['stops']),
    );
  }

  static List<Route> fromJsonList(List<dynamic> json) {
    return json
        .map((e) => Route.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  /// Turn-by-turn driving directions along this route.
  /// Only available if [RouteParameters.returnDirections] was enabled.
  /// See also:
  ///  * [DirectionManeuver]
  final List<DirectionManeuver> directionManeuvers;

  /// Time when the route begins (departing from the first stop) in the current locale of the device.
  final DateTime? startTime;

  /// Time zone shift in minutes (based on the time zone of the last stop) for the start time.
  final double startTimeShift;

  /// Time when the route ends (arriving at the last stop) in the current locale of the device.
  final DateTime? endTime;

  /// Time zone shift in minutes (based on the time zone of the last stop) for the end time.
  final double endTimeShift;

  /// Total distance (in meters) covered by the route.
  final double totalLength;

  /// The route geometry.
  final Polyline? routeGeometry;

  /// The stops visited along this route.
  /// Only available if [RouteParameters.returnStop] was enabled.
  /// The sequence stops are visited in the route may be different from
  /// the order they are present in the list if
  /// [RouteParameters.findBestSequence] is enabled.
  final List<Stop> stops;

  /// Name of the route.
  final String routeName;

  /// Overall time (in minutes) taken by the route from start to end.
  /// This includes [travelTime] and [waitTime].
  final double totalTime;

  /// Total time (in minutes) spent travelling along the route.
  final double travelTime;

  /// Total time (in munutes) that the route was late in arriving within
  /// permissible time windows for stops.
  /// Only applicable if time windows were specified for stops.
  final double violationTime;

  /// Total time (in minutes) spent at stops waiting for time windows to open.
  /// Only applicable if time windows were specified for stops.
  final double waitTime;

  @override
  String toString() {
    return 'Route(directionManeuvers: $directionManeuvers, startTime: $startTime, startTimeShift: $startTimeShift, endTime: $endTime, endTimeShift: $endTimeShift, totalLength: $totalLength, routeGeometry: $routeGeometry, stops: $stops, routeName: $routeName, totalTime: $totalTime, travelTime: $travelTime, violationTime: $violationTime, waitTime: $waitTime)';
  }
}
