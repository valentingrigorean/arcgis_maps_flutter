part of arcgis_maps_flutter;

@immutable
class DirectionMessage {
  const DirectionMessage._({
    required this.type,
    required this.text,
  });

  factory DirectionMessage.fromJson(Map<String, dynamic> json) {
    return DirectionMessage._(
      type: _parseMessageType(json['type'] as int),
      text: json['text'],
    );
  }

  static List<DirectionMessage> fromJsonList(List<dynamic> json) {
    return json.map((e) => DirectionMessage.fromJson(e.cast<String,dynamic>())).toList();
  }

  final DirectionMessageType type;

  final String text;
}

DirectionMessageType _parseMessageType(int type) {
  if (type < 9) {
    return DirectionMessageType.unknown;
  }
  return DirectionMessageType.values[type - 9];
}
