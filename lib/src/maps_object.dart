
/// A common interface for maps types.
abstract class MapsObject<T> {
  const MapsObject();

  /// A identifier for this object.
  String get mapsId;

  /// Returns a duplicate of this object.
  T clone();

  /// Converts this object to something serializable in JSON.
  Object toJson();
}
