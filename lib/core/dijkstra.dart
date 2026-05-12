import '../models/route_result.dart';
import 'campus_graph.dart';
import 'priority_queue.dart';

/// Dijkstra's Shortest Path Algorithm implementation for campus evacuation.
///
/// DSA Concept: Greedy shortest-path using Min-Heap Priority Queue.
///
/// Time Complexity:  O((V + E) log V)
/// Space Complexity: O(V)
///
/// Given a source node and a set of safe exit node IDs, this finds the
/// shortest path to the nearest reachable exit while avoiding blocked nodes.
class DijkstraEngine {
  final CampusGraph graph;

  DijkstraEngine(this.graph);

  // ---------------------------------------------------------------------------
  // Core Algorithm
  // ---------------------------------------------------------------------------

  /// Computes the shortest evacuation route from [sourceId] to any of the
  /// provided [exitNodeIds], avoiding blocked (danger zone) nodes.
  ///
  /// Returns a [RouteResult] with the path, total distance, and estimated time.
  RouteResult findShortestRoute({
    required String sourceId,
    required Set<String> exitNodeIds,
  }) {
    // Distance map: node → shortest known distance from source
    final Map<String, double> dist = {};

    // Previous node map: node → predecessor on shortest path
    final Map<String, String?> prev = {};

    // Initialize all distances to infinity
    for (final nodeId in graph.allNodeIds) {
      dist[nodeId] = double.infinity;
      prev[nodeId] = null;
    }
    dist[sourceId] = 0.0;

    // Min-heap priority queue seeded with the source node
    final pq = MinHeapPriorityQueue();
    pq.insert(sourceId, 0.0);

    final Set<String> visited = {};

    // Main Dijkstra loop
    while (!pq.isEmpty) {
      final current = pq.extractMin();
      final u = current.nodeId;

      if (visited.contains(u)) continue;
      visited.add(u);

      // Early exit: we've reached a safe exit node
      if (exitNodeIds.contains(u) && u != sourceId) {
        return _buildResult(u, dist, prev);
      }

      // Relax all neighbors of u
      for (final edge in graph.getNeighbors(u)) {
        final v = edge.destination;
        if (visited.contains(v)) continue;

        final newDist = dist[u]! + edge.weight;
        if (newDist < (dist[v] ?? double.infinity)) {
          dist[v] = newDist;
          prev[v] = u;
          pq.insert(v, newDist);
        }
      }
    }

    // No reachable exit was found
    return RouteResult.noRoute;
  }

  // ---------------------------------------------------------------------------
  // Path Reconstruction
  // ---------------------------------------------------------------------------

  /// Reconstructs the path from source to [targetId] using the [prev] map.
  RouteResult _buildResult(
    String targetId,
    Map<String, double> dist,
    Map<String, String?> prev,
  ) {
    final List<String> path = [];
    String? current = targetId;

    // Walk backwards through the predecessor map
    while (current != null) {
      path.insert(0, current);
      current = prev[current];
    }

    final pathNames = path
        .map((id) => graph.getNode(id)?.name ?? id)
        .toList();

    final totalWeight = dist[targetId] ?? 0.0;

    // Assume 1 meter ≈ 1 second walking speed at 1 m/s → convert to minutes
    final estimatedMinutes = totalWeight / 60.0;

    return RouteResult(
      path: path,
      totalWeight: totalWeight,
      pathNames: pathNames,
      routeFound: true,
      estimatedMinutes: estimatedMinutes,
    );
  }
}
