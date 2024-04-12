extension MapsExt<K,V> on Map<K,V>{
  void addIfPresent(K fieldName, V? value) {
    if (value != null) {
      this[fieldName] = value;
    }
  }
}