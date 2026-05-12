/// Represents the result of a Dijkstra shortest-path computation.
///
/// Contains the ordered list of node IDs forming the evacuation route,
/// total weight (distance/time), and human-readable metadata.
class RouteResult {
  /// Ordered list of campus node IDs from source to safe exit.
  final List<String> path;

  /// Total route weight (distance in meters or travel time in seconds).
  final double totalWeight;

  /// Human-readable path as a list of node names.
  final List<String> pathNames;

  /// Whether a valid safe route was found.
  final bool routeFound;

  /// Estimated evacuation time in minutes (derived from weight).
  final double estimatedMinutes;

  const RouteResult({
    required this.path,
    required this.totalWeight,
    required this.pathNames,
    required this.routeFound,
    required this.estimatedMinutes,
  });

  /// A result indicating no safe route was found.
  static const RouteResult noRoute = RouteResult(
    path: [],
    totalWeight: double.infinity,
    pathNames: [],
    routeFound: false,
    estimatedMinutes: 0,
  );

  /// Formatted path string for display (e.g., "Library → Canteen → Main Gate")
  String get formattedPath => pathNames.join(' → ');

  /// Formatted estimated distance string.
  String get formattedDistance =>
      '${totalWeight.toStringAsFixed(0)} m';

  /// Formatted estimated time string.
  String get formattedTime =>
      '${estimatedMinutes.toStringAsFixed(1)} min';
}
