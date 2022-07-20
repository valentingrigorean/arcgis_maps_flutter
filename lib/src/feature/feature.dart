part of arcgis_maps_flutter;

class Feature {
  Geometry? geometry;
  CenterPoint? centerPoint;
  FeatureTable featureTable;
  final Map<Object?, Object?> _attributes;

  Map<Object?, Object?> get attributes => _attributes;

  set attributes(Map<Object?, Object?> value) {
    _attributes
      ..clear()
      ..addAll(value);
  }

  Feature.named(
      {Map<Object?, Object?> attributes = const {},
      required this.featureTable,
      this.geometry,
      this.centerPoint})
      : _attributes = attributes;

  Feature.fromJson(Map<Object?, Object?> json)
      : this.named(
            featureTable: FeatureTable.fromJson(
                json["featureTable"] as Map<Object?, Object?>),
            attributes: json["attributes"] as Map<Object?, Object?>,
            geometry:
                Geometry.fromJson(json["geometry"] as Map<dynamic, dynamic>?),
            centerPoint: CenterPoint.fromJson(
                json['centerPoint'] as Map<Object?, Object?>));

  Map<dynamic, dynamic> toJson() {
    return {
      "featureTable": featureTable.toJson(),
      "attributes": attributes,
    };
  }
}

class FeatureTable {
  final List<FeatureTableField> _fields;

  List<FeatureTableField> get fields => _fields;

  set fields(List<FeatureTableField> value) {
    _fields
      ..clear()
      ..addAll(value);
  }

  final List<FeatureType> _featureTypes;

  List<FeatureType> get featureTypes => _featureTypes;

  set featureTypes(List<FeatureType> value) {
    _featureTypes
      ..clear()
      ..addAll(value);
  }

  final String? tableName;
  final String? displayName;

  FeatureTable.named(
      {List<FeatureTableField> fields = const [],
      List<FeatureType> featureTypes = const [],
      this.tableName,
      this.displayName})
      : _fields = fields,
        _featureTypes = featureTypes;

  FeatureTable.fromJson(Map<Object?, Object?> json)
      : this.named(
            fields: [],
            tableName: json["tableName"] as String?,
            displayName: json["displayName"] as String?,
            featureTypes: []);

  Map<String, dynamic> toJson() {
    return {
      "fields": fields.map((e) => e.toJson()).toList(),
      "tableName": tableName,
      "displayName": displayName,
      "featureTypes": featureTypes.map((e) => e.toJson()).toList()
    };
  }
}

class FeatureType {
  final dynamic id;
  final String? name;

  FeatureType.named({this.id, this.name});

  FeatureType.fromJson(Map<String, dynamic> json)
      : this.named(name: json["name"], id: json["id"]);

  Map<String, dynamic> toJson() {
    return {"name": name, "id": id};
  }
}

class FeatureTableField {
  final FeatureTableFieldType fieldType;
  final String alias;
  final String name;

  FeatureTableField(
      {required this.fieldType, required this.alias, required this.name});

  FeatureTableField.fromJson(Map<String, dynamic> json)
      : this(
            fieldType: _createFieldTypeFromString(json["fieldType"]),
            alias: json["alias"],
            name: json["name"]);

  Map<String, dynamic> toJson() {
    return {"fieldType": fieldType.name, "alias": alias, "name": name};
  }

  static FeatureTableFieldType _createFieldTypeFromString(String name) {
    return FeatureTableFieldType.values
        .firstWhere((element) => element.name == name);
  }
}

class CenterPoint {
  final num? x;
  final num? y;

  CenterPoint({required this.x, required this.y});

  CenterPoint.fromJson(Map<Object?, Object?>? json)
      : this(x: json?['x'] as num?, y: json?['y'] as num?);

  Map<String, dynamic> toJson() {
    return {"x": x, "y": y};
  }
}

enum FeatureTableFieldType {
  unknown("unknown"),
  ignore("ignore"),
  date("date"),
  oid("oid"),
  guid("guid"),
  globalid("globalid"),
  number("number"),
  text("text");

  final String name;

  const FeatureTableFieldType(this.name);
}
