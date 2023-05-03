part of arcgis_maps_flutter;

enum AttributeUnit {
  unknown,
  inches,
  feet,
  yards,
  miles,
  millimeters,
  centimeters,
  meters,
  kilometers,
  nauticalMiles,
  decimalDegrees,
  seconds,
  minutes,
  hours,
  days,
}

enum DirectionManeuverType {
  ///An unknown maneuver type.
  unknown,

  ///A stop maneuver.
  stop,

  ///A moving straight.
  straight,

  ///A bear left.
  bearLeft,

  ///A bear right.
  bearRight,

  ///A turn left.
  turnLeft,

  ///A turn right.
  turnRight,

  ///A sharp turn left.
  sharpLeft,

  ///A sharp turn right.
  sharpRight,

  ///A u-turn.
  uTurn,

  ///A maneuver connected with a ferry.
  ferry,

  ///A maneuver via roundabout.
  roundabout,

  ///A merge of several highways.
  highwayMerge,

  ///An exit from highway.
  highwayExit,

  ///A change of highway.
  highwayChange,

  ///A straight at fork.
  forkCenter,

  ///A maneuver to the left at fork.
  forkLeft,

  ///A maneuver to the right at fork.
  forkRight,

  ///A departure.
  depart,

  ///A connected with trip planning.
  tripItem,

  ///An end of ferry transfer.
  endOfFerry,

  ///A maneuver to the right on ramp.
  rampRight,

  ///A maneuver to the left on ramp.
  rampLeft,

  ///A complex maneuver: turn left, then right.
  turnLeftRight,

  ///A complex maneuver: turn right, then left.
  turnRightLeft,

  ///A complex maneuver: turn right, then right.
  turnRightRight,

  ///A complex maneuver: turn left, then left.
  turnLeftLeft,

  ///A maneuver via pedestrian ramp.
  pedestrianRamp,

  ///A maneuver using elevator.
  elevator,

  ///A maneuver using escalator.
  escalator,

  ///A maneuver using stairs.
  stairs,

  ///A passing through a door.
  doorPassage,
}

enum DirectionMessageType {
  unknown,

  /// A street name.
  streetName,

  /// An alternative street name.
  alternativeName,

  /// A signpost branch.
  branch,

  /// A signpost toward.
  toward,

  /// An intersected street name.
  crossStreet,

  /// A signpost exit.
  exit
}

enum DirectionsStyle {
  /// The driving directions generated by this style are good for desktop/printing apps.
  desktop(0),

  /// The driving directions generated by this style are good for navigation applications.
  navigation(1),

  /// The driving directions generated by this style are good for campus routing.
  campus(2),
  ;

  const DirectionsStyle(this.value);

  factory DirectionsStyle.fromValue(int value) {
    return DirectionsStyle.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DirectionsStyle.desktop,
    );
  }

  final int value;
}

enum NetworkDirectionsSupport {
  /// Directions support is unknown.
  unknown,

  /// Directions are unsupported.
  unsupported,

  /// Directions are supported.
  supported,
}

enum RouteShapeType {
  /// A none shape type.
  none(0),

  /// A straight line shape type.
  straightLine(1),

  ///  A true shape type with measures.
  trueShapeWithMeasures(2),
  ;

  const RouteShapeType(this.value);

  factory RouteShapeType.fromValue(int value) {
    return RouteShapeType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RouteShapeType.none,
    );
  }

  final int value;
}

enum UTurnPolicy {
  notAllowed(0),
  allowedAtDeadEnds(1),
  allowedAtIntersections(2),
  allowedAtDeadEndsAndIntersections(3),
  ;

  const UTurnPolicy(this.value);

  factory UTurnPolicy.fromValue(int value) {
    return UTurnPolicy.values.firstWhere(
      (e) => e.value == value,
      orElse: () => UTurnPolicy.notAllowed,
    );
  }

  final int value;
}

enum CurbApproach {
  /// An either side curb approach.
  eitherSide,

  /// A left side curb approach.
  leftSide,

  /// A right side curb approach.
  rightSide,

  /// A no U-Turn curb approach.
  noUTurn,

  /// An unknown type, used when approach is not determined.
  unknown,
}

enum LocationStatus {
  /// The element's location on the network dataset can't be determined.
  notLocated,

  /// The element has been located on the closest network location
  onClosest,

  /// The closest network location to the element is not traversable because
  /// of a restriction or barrier, so the element has been located
  /// on the closest traversable network feature instead.
  onClosestNotRestricted,

  ///  The element can't be reached during analysis.
  notReached
}

enum StopType {
  /// A location where a vehicle would arrive and/or depart.
  stop,

  /// A location between stops that a route must pass through.
  waypoint,

  /// A location where a route pauses e.g. for a required lunch break.
  restBreak
}
