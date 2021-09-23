part of arcgis_maps_flutter;

@immutable
class TimeExtent extends Equatable {
  const TimeExtent({
    this.startTime,
    this.endTime,
  });

  factory TimeExtent.singleValue(DateTime date) => TimeExtent(
        startTime: date,
        endTime: date,
      );

  final DateTime? startTime;

  final DateTime? endTime;

  bool get haveTime => startTime != null || endTime != null;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [startTime, endTime];

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
    if (startTime != null) {
      json['startTime'] = startTime!.toUtc().toIso8601String();
    }
    if (endTime != null) {
      json['endTime'] = endTime!.toUtc().toIso8601String();
    }
    return json;
  }
}
