class NativeMessage {
  final int objectId;
  final String method;
  final dynamic data;

  const NativeMessage({
    required this.objectId,
    required this.method,
    required this.data,
  });

  factory NativeMessage.fromJson(Map<String, dynamic> json) {
    return NativeMessage(
      objectId: json['objectId'] as int,
      method: json['method'] as String,
      data: json['data'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NativeMessage &&
          runtimeType == other.runtimeType &&
          objectId == other.objectId &&
          method == other.method &&
          data == other.data;

  @override
  int get hashCode => objectId.hashCode ^ method.hashCode ^ data.hashCode;

  @override
  String toString() {
    return 'NativeMessage{objectId: $objectId, method: $method, data: $data}';
  }
}
