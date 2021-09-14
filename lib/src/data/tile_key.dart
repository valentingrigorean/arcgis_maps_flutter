part of arcgis_maps_flutter;

@immutable
class TileKey {
  const TileKey({
    required this.level,
    required this.column,
    required this.row,
  });

  final int level;
  final int column;
  final int row;

  factory TileKey.fromJson(dynamic data) {
    if (data is Map<dynamic, dynamic>) {
      return TileKey(
        level: data['level'] as int,
        column: data['column'] as int,
        row: data['row'] as int,
      );
    }
    if (data is List<dynamic>) {
      return TileKey(
        level: data[0] as int,
        column: data[1] as int,
        row: data[2] as int,
      );
    }
    throw ArgumentError('Not supported');
  }

  Object toJson() {
    return [
      level,
      column,
      row,
    ];
  }

  @override
  String toString() {
    return 'TileKey{level: $level, column: $column, row: $row}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TileKey &&
          runtimeType == other.runtimeType &&
          level == other.level &&
          column == other.column &&
          row == other.row;

  @override
  int get hashCode => level.hashCode ^ column.hashCode ^ row.hashCode;
}
