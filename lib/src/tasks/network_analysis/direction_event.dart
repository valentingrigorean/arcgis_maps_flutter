part of arcgis_maps_flutter;

@immutable
class DirectionEvent {
  const DirectionEvent._({
    required this.estimatedArrivalTime,
    required this.estimatedArrivalTimeShift,
    required this.eventMessages,
    required this.eventText,
    required this.geometry,
  });

  factory DirectionEvent.fromJson(Map<String, dynamic> json) {
    return DirectionEvent._(
      estimatedArrivalTime:
          parseDateTimeSafeNullable(json['estimatedArrivalTime']),
      estimatedArrivalTimeShift: json['estimatedArrivalTimeShift'] as double,
      eventMessages: (json['eventMessages'] as List<String>),
      eventText: json['eventText'] as String,
      geometry: Geometry.fromJson(json['geometry'] as Map<String, dynamic>)
          as Point?,
    );
  }

  static List<DirectionEvent> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => DirectionEvent.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Estimated time of arrival at the event location in the current locale of the device.
  final DateTime? estimatedArrivalTime;

  /// Time zone shift in minutes (based on the event location) for the estimated arrival time.
  final double estimatedArrivalTimeShift;

  /// Informational messages about this event
  final List<String> eventMessages;

  /// Text describing the event
  final String eventText;

  /// Location of the event
  final Point? geometry;
}
