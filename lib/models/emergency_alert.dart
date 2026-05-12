import 'package:flutter/material.dart';

/// Represents an emergency alert triggered by a user.
class EmergencyAlert {
  final String id;
  final EmergencyType type;
  final String sourceNodeId;
  final DateTime timestamp;
  AlertStatus status;

  EmergencyAlert({
    required this.id,
    required this.type,
    required this.sourceNodeId,
    required this.timestamp,
    this.status = AlertStatus.pending,
  });
}

/// Types of emergencies that can be triggered.
enum EmergencyType {
  fire,
  medical,
  security,
  gasLeak,
}

/// Extension providing metadata for each emergency type.
extension EmergencyTypeExtension on EmergencyType {
  String get label {
    switch (this) {
      case EmergencyType.fire:
        return 'Fire';
      case EmergencyType.medical:
        return 'Medical';
      case EmergencyType.security:
        return 'Security';
      case EmergencyType.gasLeak:
        return 'Gas Leak';
    }
  }

  String get description {
    switch (this) {
      case EmergencyType.fire:
        return 'Fire outbreak detected. Immediate evacuation required.';
      case EmergencyType.medical:
        return 'Medical emergency. First aid team alerted.';
      case EmergencyType.security:
        return 'Security threat detected. Lockdown protocol initiated.';
      case EmergencyType.gasLeak:
        return 'Gas leak detected. Evacuate area immediately.';
    }
  }

  IconData get icon {
    switch (this) {
      case EmergencyType.fire:
        return Icons.local_fire_department_rounded;
      case EmergencyType.medical:
        return Icons.medical_services_rounded;
      case EmergencyType.security:
        return Icons.security_rounded;
      case EmergencyType.gasLeak:
        return Icons.air_rounded;
    }
  }

  Color get color {
    switch (this) {
      case EmergencyType.fire:
        return const Color(0xFFFF4500);
      case EmergencyType.medical:
        return const Color(0xFF00C6FF);
      case EmergencyType.security:
        return const Color(0xFFFFAA00);
      case EmergencyType.gasLeak:
        return const Color(0xFF00E676);
    }
  }

  int get dangerLevel {
    switch (this) {
      case EmergencyType.fire:
        return 5;
      case EmergencyType.medical:
        return 3;
      case EmergencyType.security:
        return 4;
      case EmergencyType.gasLeak:
        return 5;
    }
  }
}

/// Current processing status of an alert.
enum AlertStatus {
  pending,
  processing,
  routeGenerated,
  evacuationActive,
  resolved,
}

/// Extension providing labels and colors for alert statuses.
extension AlertStatusExtension on AlertStatus {
  String get label {
    switch (this) {
      case AlertStatus.pending:
        return 'Pending';
      case AlertStatus.processing:
        return 'Processing';
      case AlertStatus.routeGenerated:
        return 'Safe Route Generated';
      case AlertStatus.evacuationActive:
        return 'Evacuation Active';
      case AlertStatus.resolved:
        return 'Resolved';
    }
  }

  Color get color {
    switch (this) {
      case AlertStatus.pending:
        return const Color(0xFFFFAA00);
      case AlertStatus.processing:
        return const Color(0xFF00C6FF);
      case AlertStatus.routeGenerated:
        return const Color(0xFF00E676);
      case AlertStatus.evacuationActive:
        return const Color(0xFFFF4500);
      case AlertStatus.resolved:
        return const Color(0xFF9E9E9E);
    }
  }

  IconData get icon {
    switch (this) {
      case AlertStatus.pending:
        return Icons.hourglass_empty_rounded;
      case AlertStatus.processing:
        return Icons.sync_rounded;
      case AlertStatus.routeGenerated:
        return Icons.alt_route_rounded;
      case AlertStatus.evacuationActive:
        return Icons.directions_run_rounded;
      case AlertStatus.resolved:
        return Icons.check_circle_rounded;
    }
  }
}
