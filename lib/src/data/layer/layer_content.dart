part of arcgis_maps_flutter;

class SecondaryLayerContent {
  final String id;
  final String name;
  final bool visible;

  SecondaryLayerContent(
      {required this.id, required this.name, required this.visible});

  SecondaryLayerContent.fromJson(Map<dynamic, dynamic> json)
      : this(id: json['id'], name: json["name"], visible: json["visible"]);

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "visible": visible};
  }
}
