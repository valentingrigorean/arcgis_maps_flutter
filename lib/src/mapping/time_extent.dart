part of arcgis_maps_flutter;

@immutable
class TimeExtent {
  const TimeExtent({
    this.startTime,
    this.endTime,
  });

  final DateTime? startTime;

  final DateTime? endTime;

  TimeExtent union(TimeExtent otherTimeExtent) {
    if (startTime == null ||
        endTime == null ||
        otherTimeExtent.startTime == null ||
        otherTimeExtent.endTime == null) {
      return this;
    }

    return TimeExtent(
      startTime: startTime!.compareTo(otherTimeExtent.startTime!) <= 0
          ? startTime
          : otherTimeExtent.startTime,
      endTime: endTime!.compareTo(otherTimeExtent.endTime!) >= 0
          ? endTime
          : otherTimeExtent.endTime,
    );
  }

  factory TimeExtent.fromJson(Map<dynamic, dynamic> json) {
    return TimeExtent(
      startTime: DateTime.tryParse(json['startTime']),
      endTime: DateTime.tryParse(json['endTime']),
    );
  }

  Object toJson() {
    final Map<String, Object> json = {};
    if (startTime != null) json['startTime'] = startTime!.toIso8601String();
    if (endTime != null) json['endTime'] = endTime!.toIso8601String();
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeExtent &&
          runtimeType == other.runtimeType &&
          startTime == other.startTime &&
          endTime == other.endTime;

  @override
  int get hashCode => startTime.hashCode ^ endTime.hashCode;

  @override
  String toString() {
    return 'TimeExtent{startTime: $startTime, endTime: $endTime}';
  }
}
