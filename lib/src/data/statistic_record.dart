part of arcgis_maps_flutter;


class StatisticRecord {
  final Map<String, Object?> group;
  final Map<String, Object?> statistics;

  StatisticRecord({this.group = const {}, this.statistics = const {}});

  StatisticRecord.named({this.group = const {}, this.statistics = const {}});

  StatisticRecord.fromJson(Map<Object?, Object?> json)
      : this.named(group: () {
          Map<String, Object?> result = {};
          ((json["group"] as Map<Object?, Object?>?) ?? {})
              .forEach((key, value) {
            if (key is String) {
              result[key] = value;
            }
          });
          return result;
        }(), statistics: () {
          Map<String, Object?> result = {};
          ((json["statistics"] as Map<Object?, Object?>?) ?? {})
              .forEach((key, value) {
            if (key is String) {
              result[key] = value;
            }
          });
          return result;
        }());
}
