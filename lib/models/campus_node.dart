/// Represents a single node (location) in the campus graph.
///
/// Each node corresponds to a physical location on campus such as
/// a building, gate, hostel, or exit point.
class CampusNode {
  final String id;
  final String name;
  final NodeType type;

  const CampusNode({
    required this.id,
    required this.name,
    required this.type,
  });

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CampusNode && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// Enum representing the type of a campus node.
enum NodeType {
  building,
  exit,
  hostel,
  medical,
  parking,
  gate,
}

/// Extension to provide display labels and icons for node types.
extension NodeTypeExtension on NodeType {
  String get label {
    switch (this) {
      case NodeType.building:
        return 'Building';
      case NodeType.exit:
        return 'Exit';
      case NodeType.hostel:
        return 'Hostel';
      case NodeType.medical:
        return 'Medical';
      case NodeType.parking:
        return 'Parking';
      case NodeType.gate:
        return 'Gate';
    }
  }
}
