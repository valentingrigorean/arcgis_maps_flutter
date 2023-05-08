part of arcgis_maps_flutter;

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

class FeatureTableField {
  final FeatureTableFieldType fieldType;
  final String alias;
  final String name;

  FeatureTableField({
    required this.fieldType,
    required this.alias,
    required this.name,
  });

  FeatureTableField.fromJson(Map<Object?, Object?> json)
      : this(
          fieldType: _createFieldTypeFromString(json["fieldType"] as String),
          alias: json["alias"] as String,
          name: json["name"] as String,
        );

  Map<String, dynamic> toJson() {
    return {"fieldType": fieldType.name, "alias": alias, "name": name};
  }

  static FeatureTableFieldType _createFieldTypeFromString(String name) {
    return FeatureTableFieldType.values
        .firstWhere((element) => element.name == name);
  }
}

class FeatureType {
  final dynamic id;
  final String? name;

  FeatureType.named({this.id, this.name});

  FeatureType.fromJson(Map<Object?, Object?> json)
      : this.named(name: json["name"] as String?, id: json["id"]);

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "id": id,
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
      fields: ((){
        List<FeatureTableField> result = [];
        (json["fields"] as List<Object?>?)?.forEach((e) {
          if(e is Map<Object?, Object?>){
            result.add(FeatureTableField.fromJson(e)) ;
          }
        });
        return result;
      }.call()),
      tableName: json["tableName"] as String?,
      displayName: json["displayName"] as String?,
      featureTypes: ((){
        List<FeatureType> result = [];
        (json["featureTypes"] as List<Object?>?)?.forEach((e) {
          result.add(FeatureType.fromJson(e as Map<Object?, Object?>)) ;
        });
        return result;
      }).call());


  Map<String, dynamic> toJson() {
    return {
      "fields": fields.map((e) => e.toJson()).toList(),
      "tableName": tableName,
      "displayName": displayName,
      "featureTypes": featureTypes.map((e) => e.toJson()).toList()
    };
  }
}