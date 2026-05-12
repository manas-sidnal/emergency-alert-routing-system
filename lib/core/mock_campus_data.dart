import '../models/campus_node.dart';
import '../models/campus_edge.dart';
import 'campus_graph.dart';

/// Provides the pre-defined mock campus graph data.
///
/// DSA Concept: Weighted undirected graph seeded with real-world-style campus data.
///
/// Nodes represent campus locations; edges represent walkable paths with
/// weights reflecting approximate distances in meters.
class MockCampusData {
  // ---------------------------------------------------------------------------
  // Node IDs (constants for safe reference)
  // ---------------------------------------------------------------------------
  static const String mainGate = 'main_gate';
  static const String library = 'library';
  static const String csBlock = 'cs_block';
  static const String hostel = 'hostel';
  static const String auditorium = 'auditorium';
  static const String parking = 'parking';
  static const String medicalCenter = 'medical_center';
  static const String cafeteria = 'cafeteria';
  static const String sportsGround = 'sports_ground';
  static const String adminBlock = 'admin_block';
  static const String backGate = 'back_gate';
  static const String labBlock = 'lab_block';

  /// IDs of all safe exit nodes (gates / open exits).
  static const Set<String> safeExits = {mainGate, backGate, sportsGround};

  // ---------------------------------------------------------------------------
  // Graph Builder
  // ---------------------------------------------------------------------------

  /// Builds and returns a fully initialized [CampusGraph] with mock data.
  static CampusGraph buildGraph() {
    final graph = CampusGraph();

    // --- Add all nodes ---
    final nodes = [
      const CampusNode(id: mainGate,     name: 'Main Gate',      type: NodeType.gate),
      const CampusNode(id: library,      name: 'Library',        type: NodeType.building),
      const CampusNode(id: csBlock,      name: 'CS Block',       type: NodeType.building),
      const CampusNode(id: hostel,       name: 'Hostel',         type: NodeType.hostel),
      const CampusNode(id: auditorium,   name: 'Auditorium',     type: NodeType.building),
      const CampusNode(id: parking,      name: 'Parking',        type: NodeType.parking),
      const CampusNode(id: medicalCenter,name: 'Medical Center', type: NodeType.medical),
      const CampusNode(id: cafeteria,    name: 'Cafeteria',      type: NodeType.building),
      const CampusNode(id: sportsGround, name: 'Sports Ground',  type: NodeType.exit),
      const CampusNode(id: adminBlock,   name: 'Admin Block',    type: NodeType.building),
      const CampusNode(id: backGate,     name: 'Back Gate',      type: NodeType.gate),
      const CampusNode(id: labBlock,     name: 'Lab Block',      type: NodeType.building),
    ];

    for (final node in nodes) {
      graph.addNode(node);
    }

    // --- Add all edges (distances in meters) ---
    final edges = [
      // Main Gate connections
      const CampusEdge(source: mainGate,     destination: library,       weight: 120),
      const CampusEdge(source: mainGate,     destination: parking,       weight: 80),
      const CampusEdge(source: mainGate,     destination: adminBlock,    weight: 100),

      // Library connections
      const CampusEdge(source: library,      destination: csBlock,       weight: 150),
      const CampusEdge(source: library,      destination: cafeteria,     weight: 90),
      const CampusEdge(source: library,      destination: auditorium,    weight: 200),

      // CS Block connections
      const CampusEdge(source: csBlock,      destination: labBlock,      weight: 60),
      const CampusEdge(source: csBlock,      destination: hostel,        weight: 180),

      // Cafeteria connections
      const CampusEdge(source: cafeteria,    destination: adminBlock,    weight: 70),
      const CampusEdge(source: cafeteria,    destination: medicalCenter, weight: 110),

      // Admin Block connections
      const CampusEdge(source: adminBlock,   destination: auditorium,    weight: 130),
      const CampusEdge(source: adminBlock,   destination: mainGate,      weight: 100),

      // Hostel connections
      const CampusEdge(source: hostel,       destination: sportsGround,  weight: 140),
      const CampusEdge(source: hostel,       destination: backGate,      weight: 200),
      const CampusEdge(source: hostel,       destination: medicalCenter, weight: 160),

      // Sports Ground connections
      const CampusEdge(source: sportsGround, destination: backGate,      weight: 100),
      const CampusEdge(source: sportsGround, destination: parking,       weight: 220),

      // Lab Block connections
      const CampusEdge(source: labBlock,     destination: hostel,        weight: 90),
      const CampusEdge(source: labBlock,     destination: backGate,      weight: 250),

      // Parking connections
      const CampusEdge(source: parking,      destination: auditorium,    weight: 170),
    ];

    for (final edge in edges) {
      graph.addEdge(edge);
    }

    return graph;
  }

  /// Returns the [CampusNode] objects for all selectable locations.
  static List<CampusNode> get selectableLocations => [
    const CampusNode(id: library,       name: 'Library',        type: NodeType.building),
    const CampusNode(id: csBlock,       name: 'CS Block',       type: NodeType.building),
    const CampusNode(id: hostel,        name: 'Hostel',         type: NodeType.hostel),
    const CampusNode(id: auditorium,    name: 'Auditorium',     type: NodeType.building),
    const CampusNode(id: parking,       name: 'Parking',        type: NodeType.parking),
    const CampusNode(id: medicalCenter, name: 'Medical Center', type: NodeType.medical),
    const CampusNode(id: cafeteria,     name: 'Cafeteria',      type: NodeType.building),
    const CampusNode(id: labBlock,      name: 'Lab Block',      type: NodeType.building),
    const CampusNode(id: adminBlock,    name: 'Admin Block',    type: NodeType.building),
  ];
}
