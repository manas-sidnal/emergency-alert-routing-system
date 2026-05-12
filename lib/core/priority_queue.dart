import '../models/campus_edge.dart';

/// A Min-Heap Priority Queue used by Dijkstra's Algorithm.
///
/// DSA Concept: Binary Min-Heap (Priority Queue)
///
/// Each entry holds a node ID and its current shortest distance.
/// The minimum-distance node is always at the top (index 0).
///
/// Operations:
///   - insert: O(log n)
///   - extractMin: O(log n)
///   - isEmpty: O(1)
class MinHeapPriorityQueue {
  final List<_HeapEntry> _heap = [];

  /// Returns true if the queue has no elements.
  bool get isEmpty => _heap.isEmpty;

  /// Returns the number of elements in the queue.
  int get length => _heap.length;

  /// Inserts a node with its current known distance into the heap.
  void insert(String nodeId, double distance) {
    _heap.add(_HeapEntry(nodeId: nodeId, distance: distance));
    _bubbleUp(_heap.length - 1);
  }

  /// Removes and returns the entry with the minimum distance.
  _HeapEntry extractMin() {
    if (_heap.isEmpty) throw StateError('Priority queue is empty.');

    final min = _heap[0];

    // Move last element to root and sift down
    final last = _heap.removeLast();
    if (_heap.isNotEmpty) {
      _heap[0] = last;
      _siftDown(0);
    }

    return min;
  }

  // ---------------------------------------------------------------------------
  // Heap Maintenance
  // ---------------------------------------------------------------------------

  /// Moves the element at [index] up until the heap property is restored.
  void _bubbleUp(int index) {
    while (index > 0) {
      final parent = (index - 1) ~/ 2;
      if (_heap[parent].distance <= _heap[index].distance) break;
      _swap(parent, index);
      index = parent;
    }
  }

  /// Moves the element at [index] down until the heap property is restored.
  void _siftDown(int index) {
    final n = _heap.length;
    while (true) {
      int smallest = index;
      final left = 2 * index + 1;
      final right = 2 * index + 2;

      if (left < n && _heap[left].distance < _heap[smallest].distance) {
        smallest = left;
      }
      if (right < n && _heap[right].distance < _heap[smallest].distance) {
        smallest = right;
      }

      if (smallest == index) break;
      _swap(index, smallest);
      index = smallest;
    }
  }

  void _swap(int i, int j) {
    final temp = _heap[i];
    _heap[i] = _heap[j];
    _heap[j] = temp;
  }
}

/// Internal data class for heap entries.
class _HeapEntry {
  final String nodeId;
  final double distance;
  const _HeapEntry({required this.nodeId, required this.distance});
}

/// Extension to allow CampusEdge to be used conveniently with the queue.
extension CampusEdgeHeap on CampusEdge {
  _HeapEntry toHeapEntry() =>
      _HeapEntry(nodeId: destination, distance: weight);
}
