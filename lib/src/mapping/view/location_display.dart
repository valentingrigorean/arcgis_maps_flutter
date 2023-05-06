part of arcgis_maps_flutter;

abstract class LocationDisplay {
  Stream<Location> get onLocationChanged;

  Stream<AutoPanMode> get onAutoPanModeChanged;

  /// Indicates whether the location display is active or not.
  Future<bool> get started;

  /// Defines how to automatically pan the map when new location updates are received.
  /// Default is [AutoPanMode.off].
  AutoPanMode get autoPanMode;

  set autoPanMode(AutoPanMode mode);

  /// Scale that map should automatically be zoomed to upon receiving the first location update.
  /// Only applies to the first location update received after the autoPanMode
  /// goes from [AutoPanMode.off] to any other value.
  /// Defaults to 10,000.
  /// A value of 0 or less will tell the location display not to auto zoom at all.
  double get initialZoomScale;

  set initialZoomScale(double scale);

  /// Determines where to position the location symbol when [autoPanMode] is [AutoPanMode.navigation].
  /// The default is 0.125 (1/8th), which places it 1/8th of the height
  /// of the map view starting from the bottom of the map view.
  double get navigationPointHeightFactor;

  set navigationPointHeightFactor(double factor);

  /// The factor that is used to calculate a wander extent for the location symbol.
  /// The location symbol may move freely within the wander extent, but as soon as the symbol exits the wander extent, the mapview re-centers the map on the symbol.
  /// The default value for this property is 0.5, which means that
  /// the wander extent is half the size of the mapview.
  /// Permissible values are between 0 and 1.  A value of 0 implies
  /// an infinitesimal wander extent, and the map is potentially re-centered
  /// on every location update (heavy CPU & battery consumption).
  /// A value of 1 implies a wander extent equal to the size of the mapview's
  /// extent, so the location symbol may move up to the edge of the mapview
  /// before the map re-centers (light CPU & battery consumption).
  double get wanderExtentFactor;

  set wanderExtentFactor(double factor);

  /// Most recent location update provided by the dataSource property.
  /// It includes the raw information about the location and may not be in
  /// the map's spatial reference.
  Future<Location?> get location;

  /// Position of the location symbol, as provided by the most recent location
  /// update, projected to the map's spatial reference.
  Future<Point?> get mapLocation;

  /// Heading relative to the geographic North Pole. The value 0 means
  /// the device is pointed toward true north, 90 means it is pointed due east,
  /// 180 means it is pointed due south, and so on. A negative value indicates
  /// that the heading could not be determined.
  Future<double> get heading;

  /// Indicates whether the @c #courseSymbol property should be used instead of the
  /// @c #defaultSymbol property when location updates suggest the device is moving.
  bool get useCourseSymbolOnMovement;

  set useCourseSymbolOnMovement(bool useCourseSymbolOnMovement);

  /// The opacity of content (all symbols) displayed by the location display.
  /// The default value is 1.0.
  double get opacity;

  set opacity(double opacity);

  /// Indicates whether the accuracy circle around the location symbol
  /// should be displayed. Default is true.
  bool get showAccuracy;

  set showAccuracy(bool showAccuracy);

  /// Indicates whether the location symbol should be displayed. Default is true.
  bool get showLocation;

  set showLocation(bool showLocation);

  /// Indicates whether the ping symbol animating around the location symbol
  /// should be displayed. Default is true.
  bool get showPingAnimationSymbol;

  set showPingAnimationSymbol(bool showPingAnimationSymbol);

  Future<void> start();

  Future<void> stop();

  void dispose();
}
