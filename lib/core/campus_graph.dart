import '../models/campus_node.dart';
import '../models/campus_edge.dart';

/// Campus graph data structure using an adjacency list (HashMap-based).
///
/// DSA Concept: Weighted Undirected Graph using Map<String, List<CampusEdge>>
///
/// Each key is a node ID and the value is the list of outgoing edges.
/// This representation provides O(1) lookup for neighbors.
class CampusGraph {
  /// Adjacency list: Map from node ID → list of outgoing edges.
  final Map<String, List<CampusEdge>> _adjacencyList = {};

  /// Map from node ID → CampusNode for lookup.
  final Map<String, CampusNode> _nodes = {};

  /// Set of blocked node IDs (danger zones excluded from routing).
  final Set<String> _blockedNodes = {};

  // ---------------------------------------------------------------------------
  // Graph Construction
  // ---------------------------------------------------------------------------

  /// Adds a campus node to the graph.
  void addNode(CampusNode node) {
    _nodes[node.id] = node;
    _adjacencyList.putIfAbsent(node.id, () => []);
  }

  /// Adds a bidirectional weighted edge between two nodes.
  void addEdge(CampusEdge edge) {
    _adjacencyList.putIfAbsent(edge.source, () => []);
    _adjacencyList.putIfAbsent(edge.destination, () => []);

    _adjacencyList[edge.source]!.add(edge);
    // Add reverse edge for undirected graph
    _adjacencyList[edge.destination]!.add(
      CampusEdge(
        source: edge.destination,
        destination: edge.source,
        weight: edge.weight,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Danger Zone Management
  // ---------------------------------------------------------------------------

  /// Marks a node as blocked (danger zone — excluded from routing).
  void blockNode(String nodeId) => _blockedNodes.add(nodeId);

  /// Unblocks a previously blocked node.
  void unblockNode(String nodeId) => _blockedNodes.remove(nodeId);

  /// Returns whether a node is currently blocked.
  bool isBlocked(String nodeId) => _blockedNodes.contains(nodeId);

  // ---------------------------------------------------------------------------
  // Graph Access
  // ---------------------------------------------------------------------------

  /// Returns all neighbors of a given node (excluding blocked ones).
  List<CampusEdge> getNeighbors(String nodeId) {
    return (_adjacencyList[nodeId] ?? [])
        .where((e) => !_blockedNodes.contains(e.destination))
        .toList();
  }

  /// Returns a node by its ID.
  CampusNode? getNode(String nodeId) => _nodes[nodeId];

  /// Returns all nodes in the graph.
  List<CampusNode> get allNodes => _nodes.values.toList();

  /// Returns all node IDs.
  Set<String> get allNodeIds => _nodes.keys.toSet();

  /// Returns blocked node IDs.
  Set<String> get blockedNodes => Set.unmodifiable(_blockedNodes);

  /// Clears all blocked nodes.
  void clearBlockedNodes() => _blockedNodes.clear();
}
