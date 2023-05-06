part of arcgis_maps_flutter;

enum AutoPanMode {
  /// The location symbol is shown at the current location but the map view
  /// extent is unaffected, no auto-panning is performed.
  off(0),

  /// Centers the map view at the current location, and shows the location symbol.
  /// When the current location changes, the map view is automatically panned to
  /// re-center at the new location. Behaviour is affected by the wander extent factor.
  recenter(1),

  /// Pans the map view so that the current location symbol is shown near the
  /// bottom of the map view, and rotates the map view to align it with the
  /// direction of travel. When the current location or direction of
  /// travel changes the map view is automatically panned and rotated
  /// to maintain this position. To use this mode effectively, the device
  /// location must be moving at a speed greater than 0 meters per second.
  /// Behaviour is affected by the navigation point height factor.
  navigation(2),

  /// Centers the map view at the current location, rotates the map view to
  /// align with the direction in which the device is currently,
  /// and shows the location symbol. When the current location or position
  /// of the device changes, the map view is automatically panned and rotated
  /// to maintain this position, thus if the device is spun in a circle,
  /// the map view stays aligned with the real world.
  compassNavigation(3),
  ;

  const AutoPanMode(this.value);

  factory AutoPanMode.fromValue(int value) {
    return AutoPanMode.values.firstWhere(
      (e) => e.value == value,
    );
  }

  final int value;
}
