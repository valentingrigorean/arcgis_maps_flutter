part of arcgis_maps_flutter;

class StatisticResult {
  final List<StatisticRecord> results;

  StatisticResult.named({this.results = const []});

  StatisticResult.fromJson(Map<Object?, Object?> json)
      : this.named(results: () {
          var results = json["results"] as List<Object?>?;
          List<StatisticRecord> records = [];
          for (var element in (results ?? [])) {
            records.add(StatisticRecord.fromJson(element));
          }
          return records;
        }());
}

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
