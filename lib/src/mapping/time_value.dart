part of arcgis_maps_flutter;

enum TimeUnit {
  unknown,
  centuries,
  days,
  decades,
  hours,
  milliseconds,
  minutes,
  months,
  seconds,
  weeks,
  years
}

@immutable
class TimeValue {
  const TimeValue({
    required this.duration,
    required this.unit,
  });

  final double duration;

  final TimeUnit unit;

  factory TimeValue.fromJson(Map<dynamic, dynamic> json) {
    return TimeValue(
      duration: json['duration'] as double,
      unit: TimeUnit.values[json['unit']],
    );
  }

  Object toJson() {
    final Map<String, Object> json = {};
    json['duration'] = duration;
    json['unit'] = unit.index;
    return json;
  }

  bool operator >(TimeValue other) {
    if (unit == other.unit) {
      return duration > other.duration;
    }
    return toSeconds() > other.toSeconds();
  }

  bool operator <(TimeValue other) {
    if (unit == other.unit) {
      return duration < other.duration;
    }
    return toSeconds() < other.toSeconds();
  }

  double toSeconds() {
    switch (unit) {
      case TimeUnit.unknown:
        return duration;
      case TimeUnit.centuries:
        return duration * 3155695200;
      case TimeUnit.days:
        return duration * 86400;
      case TimeUnit.decades:
        return duration * 315569520;
      case TimeUnit.hours:
        return duration * 3600;
      case TimeUnit.milliseconds:
        return duration * 0.001;
      case TimeUnit.minutes:
        return duration * 60;
      case TimeUnit.months:
        return duration * 2629746;
      case TimeUnit.seconds:
        return duration;
      case TimeUnit.weeks:
        return duration * 604800;
      case TimeUnit.years:
        return duration * 31556952;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeValue &&
          runtimeType == other.runtimeType &&
          duration == other.duration &&
          unit == other.unit;

  @override
  int get hashCode => duration.hashCode ^ unit.hashCode;

  @override
  String toString() {
    return 'TimeValue{duration: $duration, unit: $unit}';
  }
}
