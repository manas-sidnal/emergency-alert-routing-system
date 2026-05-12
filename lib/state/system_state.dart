import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/campus_node.dart';
import '../models/emergency_alert.dart';
import '../models/route_result.dart';
import '../core/campus_graph.dart';
import '../core/dijkstra.dart';
import '../core/mock_campus_data.dart';

/// Centralized state manager for the Emergency Alert Routing System.
///
/// Uses [ChangeNotifier] so all UI widgets subscribed via [ListenableBuilder]
/// or [AnimatedBuilder] are automatically rebuilt on state changes.
///
/// Responsibilities:
///   - Maintain campus graph
///   - Maintain alert queue (FIFO)
///   - Manage active emergency state
///   - Trigger route computation (Dijkstra)
///   - Drive activity feed for status screen
class SystemState extends ChangeNotifier {
  // ---------------------------------------------------------------------------
  // Campus Graph
  // ---------------------------------------------------------------------------

  /// The campus graph (adjacency list of weighted nodes/edges).
  late final CampusGraph _graph;

  /// Dijkstra engine bound to the campus graph.
  late final DijkstraEngine _dijkstra;

  SystemState() {
    _graph = MockCampusData.buildGraph();
    _dijkstra = DijkstraEngine(_graph);
  }

  CampusGraph get graph => _graph;

  // ---------------------------------------------------------------------------
  // Alert Queue (FIFO)
  // ---------------------------------------------------------------------------

  /// Queue of all incoming emergency alerts (FIFO processing order).
  final List<EmergencyAlert> _alertQueue = [];

  List<EmergencyAlert> get alertQueue => List.unmodifiable(_alertQueue);

  /// The currently active (most recently triggered) alert.
  EmergencyAlert? get activeAlert =>
      _alertQueue.isEmpty ? null : _alertQueue.last;

  // ---------------------------------------------------------------------------
  // Current Emergency State
  // ---------------------------------------------------------------------------

  EmergencyType? _selectedEmergencyType;
  CampusNode? _selectedLocation;
  RouteResult? _currentRoute;
  AlertStatus _currentStatus = AlertStatus.pending;
  bool _emergencyActive = false;

  EmergencyType? get selectedEmergencyType => _selectedEmergencyType;
  CampusNode? get selectedLocation => _selectedLocation;
  RouteResult? get currentRoute => _currentRoute;
  AlertStatus get currentStatus => _currentStatus;
  bool get emergencyActive => _emergencyActive;

  // ---------------------------------------------------------------------------
  // Detected Location (set by LocationDetectionScreen after mock GPS)
  // ---------------------------------------------------------------------------

  CampusNode? _detectedLocation;

  /// The campus node that was auto-detected via mock GPS simulation.
  CampusNode? get detectedLocation => _detectedLocation;

  /// Called by [LocationDetectionScreen] after mock detection completes.
  void setDetectedLocation(CampusNode node) {
    _detectedLocation = node;
    _selectedLocation = node;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Activity Feed
  // ---------------------------------------------------------------------------

  final List<ActivityEvent> _activityFeed = [];
  List<ActivityEvent> get activityFeed =>
      List.unmodifiable(_activityFeed.reversed.toList());

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  /// Sets the selected emergency type on the trigger screen.
  void selectEmergencyType(EmergencyType type) {
    _selectedEmergencyType = type;
    notifyListeners();
  }

  /// Sets the selected campus location on the trigger screen.
  void selectLocation(CampusNode node) {
    _selectedLocation = node;
    notifyListeners();
  }

  /// Triggers an SOS alert from [location] for [type] emergency.
  ///
  /// Enqueues the alert, updates status, and computes the Dijkstra route.
  Future<void> triggerSOS({
    required EmergencyType type,
    required CampusNode location,
  }) async {
    _emergencyActive = true;
    _currentStatus = AlertStatus.processing;
    _currentRoute = null;
    _activityFeed.clear();

    final alert = EmergencyAlert(
      id: 'ALT-${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      sourceNodeId: location.id,
      timestamp: DateTime.now(),
      status: AlertStatus.processing,
    );

    _alertQueue.add(alert);
    _addActivity('🚨 SOS triggered from ${location.name}');
    _addActivity('📡 Scanning nearby campus nodes...');
    notifyListeners();

    // Simulate async processing delay (no real network — pure simulation)
    await Future.delayed(const Duration(milliseconds: 800));

    _addActivity('👥 Nearby users alerted via campus broadcast');
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    // Run Dijkstra's algorithm
    final result = _dijkstra.findShortestRoute(
      sourceId: location.id,
      exitNodeIds: MockCampusData.safeExits,
    );

    if (result.routeFound) {
      _currentRoute = result;
      alert.status = AlertStatus.routeGenerated;
      _currentStatus = AlertStatus.routeGenerated;

      _addActivity('🗺️ Dijkstra\'s algorithm executed successfully');
      _addActivity(
          '✅ Safe route found: ${result.formattedPath}');
      _addActivity(
          '⏱️ Estimated evacuation time: ${result.formattedTime}');

      await Future.delayed(const Duration(milliseconds: 400));

      alert.status = AlertStatus.evacuationActive;
      _currentStatus = AlertStatus.evacuationActive;
      _addActivity('🏃 Evacuation protocol activated');
    } else {
      _addActivity('⚠️ No direct safe route found');
      _addActivity('🔄 Attempting alternate route calculation...');
      _currentStatus = AlertStatus.processing;
    }

    notifyListeners();
  }

  /// Simulates a route recalculation (e.g., a path became blocked).
  Future<void> recalculateRoute() async {
    if (_selectedLocation == null) return;

    _addActivity('🚧 Blocked path detected — recalculating...');
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    // Block a random intermediate node and re-run Dijkstra
    if (_currentRoute != null && _currentRoute!.path.length > 2) {
      final intermediateNode = _currentRoute!.path[1];
      _graph.blockNode(intermediateNode);
      _addActivity('❌ Node blocked: ${_graph.getNode(intermediateNode)?.name}');
    }

    final result = _dijkstra.findShortestRoute(
      sourceId: _selectedLocation!.id,
      exitNodeIds: MockCampusData.safeExits,
    );

    _graph.clearBlockedNodes();

    if (result.routeFound) {
      _currentRoute = result;
      _addActivity('✅ Alternate route: ${result.formattedPath}');
    } else {
      _addActivity('⚠️ No alternate route available');
    }

    notifyListeners();
  }

  /// Resolves the current emergency and resets state.
  void resolveEmergency() {
    if (_alertQueue.isNotEmpty) {
      _alertQueue.last.status = AlertStatus.resolved;
    }
    _currentStatus = AlertStatus.resolved;
    _emergencyActive = false;
    _addActivity('🟢 Emergency resolved. Campus returning to normal.');
    notifyListeners();
  }

  /// Resets the entire system state for a fresh alert.
  void resetState() {
    _selectedEmergencyType = null;
    _selectedLocation = null;
    _detectedLocation = null;
    _currentRoute = null;
    _currentStatus = AlertStatus.pending;
    _emergencyActive = false;
    _activityFeed.clear();
    _graph.clearBlockedNodes();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Internal Helpers
  // ---------------------------------------------------------------------------

  void _addActivity(String message) {
    _activityFeed.add(ActivityEvent(
      message: message,
      timestamp: DateTime.now(),
    ));
  }
}

/// A single item in the activity feed displayed on the status screen.
class ActivityEvent {
  final String message;
  final DateTime timestamp;

  ActivityEvent({required this.message, required this.timestamp});

  String get timeLabel {
    final t = timestamp;
    return '${t.hour.toString().padLeft(2, '0')}:'
        '${t.minute.toString().padLeft(2, '0')}:'
        '${t.second.toString().padLeft(2, '0')}';
  }
}

// =============================================================================
// InheritedWidget — provides SystemState down the widget tree
// =============================================================================

/// Provides [SystemState] to any descendant widget via
/// `SystemStateProvider.of(context)`.
class SystemStateProvider extends InheritedNotifier<SystemState> {
  const SystemStateProvider({
    super.key,
    required SystemState state,
    required super.child,
  }) : super(notifier: state);

  /// Retrieves the nearest [SystemState] from the widget tree.
  static SystemState of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<SystemStateProvider>();
    assert(provider != null, 'No SystemStateProvider found in widget tree.');
    return provider!.notifier!;
  }
}
