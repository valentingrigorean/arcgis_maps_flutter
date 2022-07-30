class NativeMessage {
  final String objectId;
  final String method;
  final dynamic arguments;

  const NativeMessage({
    required this.objectId,
    required this.method,
    required this.arguments,
  });

  factory NativeMessage.fromJson(Map<dynamic, dynamic> json) {
    return NativeMessage(
      objectId: json['objectId'] as String,
      method: json['method'] as String,
      arguments: json['arguments'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NativeMessage &&
          runtimeType == other.runtimeType &&
          objectId == other.objectId &&
          method == other.method &&
          arguments == other.arguments;

  @override
  int get hashCode => objectId.hashCode ^ method.hashCode ^ arguments.hashCode;

  @override
  String toString() {
    return 'NativeMessage{objectId: $objectId, method: $method, arguments: $arguments}';
  }
}
