part of arcgis_maps_flutter;

@immutable
class PortalItem {
  PortalItem({
    required this.portal,
    required this.itemId,
  });

  final Portal portal;
  final String itemId;

  Object toJson() {
    final Map<String, Object> json = <String, Object>{};
    json['portal'] = portal.toJson();
    json['itemId'] = itemId;
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PortalItem &&
          runtimeType == other.runtimeType &&
          portal == other.portal &&
          itemId == other.itemId;

  @override
  int get hashCode => portal.hashCode ^ itemId.hashCode;
}
