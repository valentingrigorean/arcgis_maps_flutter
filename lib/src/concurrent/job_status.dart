part of arcgis_maps_flutter;

enum JobStatus {
  notStarted(0),
  started(1),
  paused(2),
  succeeded(3),
  failed(4);

  const JobStatus(this.value);

  factory JobStatus.fromValue(int value) {
    return JobStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => JobStatus.notStarted,
    );
  }

  final int value;
}
