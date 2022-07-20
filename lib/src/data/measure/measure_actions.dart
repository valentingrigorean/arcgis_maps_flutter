part of arcgis_maps_flutter;

enum MeasureAction {
  enter("enter"),
  makePoint("makePoint"),
  revoke("revoke"),
  clear("clear"),
  exit("exit");

  final String name;

  const MeasureAction(this.name);
}
