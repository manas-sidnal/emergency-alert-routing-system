/// Represents a weighted edge (path) between two campus nodes.
///
/// The weight can represent distance, travel time, or risk level.
class CampusEdge {
  final String source;
  final String destination;

  /// Weight of the edge — represents distance in meters.
  final double weight;

  const CampusEdge({
    required this.source,
    required this.destination,
    required this.weight,
  });
}
