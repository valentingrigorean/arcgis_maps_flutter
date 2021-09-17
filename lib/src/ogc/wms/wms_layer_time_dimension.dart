part of arcgis_maps_flutter;

@immutable
class WmsLayerTimeDimension extends Equatable {
  const WmsLayerTimeDimension({
    required this.dates,
    this.parent,
  });

  final WmsLayerDimension? parent;

  final List<WmsLayerTimeDimensionInfo> dates;

  @override
  List<Object?> get props => [dates];
}

@immutable
class IsoDurationValues extends Equatable {
  const IsoDurationValues({
    required this.duration,
    required this.months,
    required this.years,
  });

  final Duration duration;
  final int months;
  final int years;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [duration, years, months];
}

@immutable
class WmsLayerTimeDimensionInfo extends Equatable {
  const WmsLayerTimeDimensionInfo({
    required this.timeExtent,
    this.interval,
  });

  final TimeExtent timeExtent;
  final IsoDurationValues? interval;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [timeExtent, interval];
}

extension WmsLayerTimeDimensionExtension on WmsLayerDimension {
  WmsLayerTimeDimension? get timeDimension {
    if (extent.isEmpty) {
      return null;
    }
    if (name.toLowerCase() != 'time') {
      return null;
    }

    final datesStr = extent.split(',');
    var dates = <WmsLayerTimeDimensionInfo>[];
    for (final date in datesStr) {
      var timeDimensionInfo = _parseTimeDimensionInfo(date);
      if (timeDimensionInfo != null) {
        dates.add(timeDimensionInfo);
      }
    }
    if (dates.isEmpty) {
      return null;
    }
    return WmsLayerTimeDimension(
      dates: dates,
      parent: this,
    );
  }

  WmsLayerTimeDimensionInfo? _parseTimeDimensionInfo(String date) {
    final values = date.split('/');
    var startDate = _getDateOrInterval(values[0]);

    if (startDate == null) {
      if (date.length == 7) {
        date += '-01T00:00:00.0Z';
        var parseDate = DateTime.parse(date);
        return WmsLayerTimeDimensionInfo(
          timeExtent: TimeExtent(
            startTime: parseDate,
            endTime: Jiffy(parseDate)
                .add(months: 1)
                .subtract(
                  duration: const Duration(milliseconds: 1),
                )
                .dateTime,
          ),
        );
      }
    }

    if (startDate is DateTime && date.length == 10) {
      date += 'T00:00:00.0Z';
      var parseDate = DateTime.parse(date);
      return WmsLayerTimeDimensionInfo(
        timeExtent: TimeExtent(
          startTime: parseDate,
          endTime: parseDate
              .add(const Duration(days: 1))
              .subtract(const Duration(milliseconds: 1)),
        ),
      );
    }

    if (values.length == 1) {
      if (startDate is DateTime) {
        return WmsLayerTimeDimensionInfo(
          timeExtent: TimeExtent(
            startTime: startDate,
            endTime: startDate,
          ),
        );
      }
      if (startDate is IsoDurationValues) {
        return WmsLayerTimeDimensionInfo(
          timeExtent: TimeExtent(
            startTime: DateTime.now().toUtc(),
          ),
          interval: startDate,
        );
      }
      return null;
    }
    var endDate = _getDateOrInterval(values[1]);
    if (startDate is IsoDurationValues && endDate is DateTime) {
      startDate = endDate.subtractDurationValues(startDate);
    } else if (startDate is DateTime && endDate is IsoDurationValues) {
      endDate = startDate.addDurationValues(endDate);
    }

    if (values.length == 2) {
      return WmsLayerTimeDimensionInfo(
        timeExtent: TimeExtent(
          startTime: startDate as DateTime,
          endTime: endDate as DateTime,
        ),
      );
    }

    var interval = _getDateOrInterval(values[2]);

    return WmsLayerTimeDimensionInfo(
      timeExtent: TimeExtent(
        startTime: startDate as DateTime,
        endTime: endDate as DateTime,
      ),
      interval: interval as IsoDurationValues?,
    );
  }

  Object? _getDateOrInterval(String value) {
    if (value == 'PRESENT') {
      return DateTime.now().toUtc();
    }
    final date = DateTime.tryParse(value);
    if (date != null) {
      return date;
    }

    final interval = _toDuration(value);
    if (interval != null) {
      return interval;
    }

    // if(value.length == 7){
    //   value += '-01T00:00:00.0Z';
    //   return DateTime.parse(value + '-01T00:00:00.0Z');
    // }
    return null;
  }

  IsoDurationValues? _toDuration(String isoString) {
    if (!RegExp(
            r"^(-|\+)?P(?:([-+]?[0-9,.]*)Y)?(?:([-+]?[0-9,.]*)M)?(?:([-+]?[0-9,.]*)W)?(?:([-+]?[0-9,.]*)D)?(?:T(?:([-+]?[0-9,.]*)H)?(?:([-+]?[0-9,.]*)M)?(?:([-+]?[0-9,.]*)S)?)?$")
        .hasMatch(isoString)) {
      return null;
    }
    final years = _parseTime(isoString, "Y");
    final months = _parseTime(isoString, 'M');
    // so we can get minutes aswell
    isoString = isoString.replaceFirst(RegExp(r"(?:([-+]?[0-9,.]*)M)"), '');

    final weeks = _parseTime(isoString, "W");
    final days = _parseTime(isoString, "D");
    final hours = _parseTime(isoString, "H");
    final minutes = _parseTime(isoString, "M");
    final seconds = _parseTime(isoString, "S");

    return IsoDurationValues(
      duration: Duration(
        days: days + (weeks * 7),
        hours: hours,
        minutes: minutes,
        seconds: seconds,
      ),
      years: years,
      months: months,
    );
  }

  /// Private helper method for extracting a time value from the ISO8601 string.
  int _parseTime(String duration, String timeUnit) {
    final timeMatch = RegExp(r"\d+" + timeUnit).firstMatch(duration);

    if (timeMatch == null) {
      return 0;
    }
    final timeString = timeMatch.group(0)!;
    return int.parse(timeString.substring(0, timeString.length - 1));
  }
}

extension DateTimeExtension on DateTime {
  DateTime addDurationValues(IsoDurationValues values) {
    return Jiffy(this)
        .add(
          years: values.years,
          months: values.months,
          duration: values.duration,
        )
        .dateTime;
  }

  DateTime subtractDurationValues(IsoDurationValues values) {
    return Jiffy(this)
        .subtract(
          years: values.years,
          months: values.months,
          duration: values.duration,
        )
        .dateTime;
  }
}
