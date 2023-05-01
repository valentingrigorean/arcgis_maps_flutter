part of arcgis_maps_flutter;

class StatisticsQueryParameters {
  final Iterable<StatisticDefinition> statisticDefinitions;
  final Geometry? geometry;
  final String? whereClause;
  final SpatialRelationship? spatialRelationship;
  final List<String> groupByFieldNames;
  final List<OrderBy> orderByFields;

  StatisticsQueryParameters({
    this.statisticDefinitions = const [],
    this.groupByFieldNames = const [],
    this.orderByFields = const [],
    this.geometry,
    this.whereClause,
    this.spatialRelationship,
  }) : assert(statisticDefinitions.isNotEmpty);

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
      "statisticType": statisticType.alias,
      "outputAlias": outputAlias
    };
  }
}

enum StatisticType {
  average("AVERAGE"),
  count("COUNT"),
  maximum("MAXIMUM"),
  minimum("MINIMUM"),
  standardDeviation("STANDARD_DEVIATION"),
  sum("SUM"),
  variance("VARIANCE");

  final String alias;

  const StatisticType(this.alias);
}

class OrderBy {
  final String fieldName;
  final SortOrder sortOrder;

  OrderBy(this.fieldName, this.sortOrder);

  Map<String, dynamic> toJson() {
    return {"fieldName": fieldName, "sortOrder": sortOrder.alias};
  }
}
