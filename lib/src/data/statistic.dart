part of arcgis_maps_flutter;

enum StatisticType {
  average(0),
  count(1),
  maximum(2),
  minimum(3),
  standardDeviation(4),
  sum(5),
  variance(6);

  final int value;

  const StatisticType(this.value);
}

@immutable
class OrderBy {
  final String fieldName;
  final SortOrder sortOrder;

  const OrderBy({
    required this.fieldName,
    required this.sortOrder,
  });

  Map<String, dynamic> toJson() {
    return {
      "fieldName": fieldName,
      "sortOrder": sortOrder.value,
    };
  }
}

@immutable
class StatisticsQueryParameters {
  StatisticsQueryParameters({
    this.statisticDefinitions = const [],
    this.groupByFieldNames = const [],
    this.orderByFields = const [],
    this.geometry,
    this.whereClause,
    this.spatialRelationship,
  }) : assert(statisticDefinitions.isNotEmpty);

  final List<StatisticDefinition> statisticDefinitions;
  final Geometry? geometry;
  final String? whereClause;
  final SpatialRelationship? spatialRelationship;
  final List<String> groupByFieldNames;
  final List<OrderBy> orderByFields;

  Map<String, dynamic> toJson() {
    return {
      "statisticDefinitions":
          statisticDefinitions.map((e) => e.toJson()).toList(),
      "geometry": geometry?.toJson(),
      "whereClause": whereClause,
      "spatialRelationship": spatialRelationship?.value,
      "groupByFieldNames": groupByFieldNames,
      "orderByFields": orderByFields.map((e) => e.toJson()).toList()
    };
  }
}

class StatisticDefinition {
  final String fieldName;
  final StatisticType statisticType;
  final String? outputAlias;

  StatisticDefinition({
    required this.fieldName,
    required this.statisticType,
    this.outputAlias,
  });

  StatisticDefinition.named({
    required this.fieldName,
    required this.statisticType,
    this.outputAlias,
  });

  Map<String, dynamic> toJson() {
    return {
      "fieldName": fieldName,
      "statisticType": statisticType.value,
      "outputAlias": outputAlias
    };
  }
}
