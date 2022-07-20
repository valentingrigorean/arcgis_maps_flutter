part of arcgis_maps_flutter;

class Feature {
  FeatureTable featureTable;
  final Map<String, dynamic> _attributes;

  Map<String, dynamic> get attributes => _attributes;

  set attributes(Map<String, dynamic> value) {
    _attributes
      ..clear()
      ..addAll(value);
  }

  Feature.named(
      {Map<String, dynamic> attributes = const {},
      required this.featureTable})
      : _attributes = attributes;
  Feature.fromJson(Map<String, dynamic> json)
      : this.named(
          featureTable:  FeatureTable.fromJson(json["featureTable"]),
          attributes: json["attributes"],
        );

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

  FeatureTable.fromJson(Map<String, dynamic> json)
      : this.named(
            fields: (json["fields"] as List<dynamic>)
                .map((e) => FeatureTableField.fromJson(e))
                .toList(),
            tableName: json["tableName"],
            displayName: json["displayName"],
            featureTypes: (json["featureTypes"] as List<dynamic>)
                .map((e) => FeatureType.fromJson(e))
                .toList());

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
