part of arcgis_maps_flutter;

@immutable
class Stop {
  const Stop({
    this.arrivalCurbApproach = CurbApproach.unknown,
    this.departureCurbApproach = CurbApproach.unknown,
    this.curbApproach = CurbApproach.eitherSide,
    this.currentBearing = double.nan,
    this.currentBearingTolerance = double.nan,
    this.distanceToNetworkLocation = double.nan,
    required AGSPoint point,
    this.arrivalTime,
    this.arrivalTimeShift = 0,
    this.departureTime,
    this.departureTimeShift = 0,
    this.timeWindowStart,
    this.timeWindowEnd,
    this.locationStatus = LocationStatus.notLocated,
    this.name = '',
    this.stopType = StopType.stop,
    this.stopID = -1,
    this.navigationLatency = double.nan,
    this.navigationSpeed = double.nan,
    this.routeName = '',
    this.sequence = 0,
    this.violationTime = 0,
    this.waitTime = 0,
  }) : geometry = point;

  /// Specifies the direction a vehicle arrives at this stop.
  final CurbApproach arrivalCurbApproach;

  /// Specifies the direction a vehicle departs from the stop.
  final CurbApproach departureCurbApproach;

  /// Specifies the direction a vehicle may arrive at or depart from the stop.
  /// For example, a school bus must approach and depart a school
  /// from its door side so that students entering/exiting
  /// the bus will not have to cross the street.
  final CurbApproach curbApproach;

  /// The current bearing in degrees.
  /// Current bearing in degrees, measured clockwise from true north.
  /// Typical values are 0 to 360 or NaN,
  /// negative values will be subtracted from 360 (e.g. -15 => 345),
  /// values greater than 360 will be have 360
  /// subtracted from them (e.g. 385 => 25). For this property to be used the
  /// bearing tolerance also has to be set.
  final double currentBearing;

  /// The current bearing tolerance in degrees. Valid values are 0 to 180 or NaN.
  final double currentBearingTolerance;

  /// The distance to the closest location on the underlying network in meters.
  final double distanceToNetworkLocation;

  /// Location the stop should be placed.
  final AGSPoint? geometry;

  /// Time of arrival at the stop.
  final DateTime? arrivalTime;

  /// Time zone shift in minutes for the arrival time.
  final double arrivalTimeShift;

  /// Time of departure from the stop.
  final DateTime? departureTime;

  /// Time zone shift in minutes for the departure time.
  final double departureTimeShift;

  /// The begining time of a permissible time window for the stop.
  /// The route will attempt to visit the stop only within its time window,
  /// if possible. Can be nil if you don't want to specify a time window constraint.
  final DateTime? timeWindowStart;

  /// The ending time of a permissible time window for the stop.
  /// The route will attempt to visit the stop only within its time window,
  /// if possible. Can be nil if you don't want to specify a time window constraint.
  final DateTime? timeWindowEnd;

  /// The status of the stop's location on the underlying network.
  final LocationStatus locationStatus;

  /// Name of the stop
  final String name;

  /// Type of stop
  final StopType stopType;

  /// Stop ID.
  /// This is a caller supplied foreign key that can be used to associate
  /// output stops with input stops.
  final int stopID;

  /// The navigation latency in seconds.
  final double navigationLatency;

  /// The navigation speed in meters per second.
  final double navigationSpeed;

  //TODO(vali): add AGSNetworkLocation

  /// Name of the route to which this stop belongs. You can use this to group stops into separate routes.
  final String routeName;

  /// The order in which stop is visited along the route.
  /// A value of 1 implies it is the first stop, and so on.
  final int sequence;

  /// The time (in minutes) by which the route arrives later than the
  /// permissible time window for the stop.
  /// This is the difference between [localArrivalTime] and [localTimeWindowEnd]
  final double violationTime;

  /// The time (in minutes) spent at the stop waiting for the time window
  /// to open when the route arrives early
  /// This is the difference between [localArrivalTime] and [localTimeWindowEnd]
  final double waitTime;
}
