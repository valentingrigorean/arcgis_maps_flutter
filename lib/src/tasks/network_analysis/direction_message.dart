part of arcgis_maps_flutter;

enum DirectionMessageType {
  unknown,

  /// A street name.
  streetName,

  /// An alternative street name.
  alternativeName,

  /// A signpost branch.
  branch,

  /// A signpost toward.
  toward,

  /// An intersected street name.
  crossStreet,

  /// A signpost exit.
  exit
}

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
    return json.map((e) => DirectionMessage.fromJson(e)).toList();
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
