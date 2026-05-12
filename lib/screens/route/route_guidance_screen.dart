import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/route_result.dart';
import '../../state/system_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/route_node_card.dart';
import '../../widgets/status_banner.dart';
import '../../models/emergency_alert.dart';

/// Route Guidance Screen — displays the computed shortest evacuation path.
///
/// Features:
///   - Safe exit found status card with green glow
///   - Dijkstra route summary (path, distance, time)
///   - Node-by-node route visualization with connector lines
///   - Emergency severity banner
///   - Nearby users alerted indicator
///   - Route recalculation trigger
class RouteGuidanceScreen extends StatelessWidget {
  const RouteGuidanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = SystemStateProvider.of(context);
    final route = state.currentRoute;
    final alert = state.activeAlert;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildAppBar(context),
      body: route == null || !route.routeFound
          ? _buildNoRoute()
          : SafeArea(
              child: SingleChildScrollView(
                padding: AppTheme.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (alert != null) _buildSeverityBanner(alert),
                    const SizedBox(height: AppTheme.spacingMD),
                    _buildSafeExitCard(route),
                    const SizedBox(height: AppTheme.spacingMD),
                    _buildMetricsRow(route),
                    const SizedBox(height: AppTheme.spacingLG),
                    _buildNearbyUsersCard(),
                    const SizedBox(height: AppTheme.spacingLG),
                    _sectionLabel('EVACUATION ROUTE'),
                    const SizedBox(height: 16),
                    _buildRouteVisualization(route),
                    const SizedBox(height: AppTheme.spacingLG),
                    _buildAlgorithmInfo(route),
                    const SizedBox(height: AppTheme.spacingLG),
                    _buildRecalculateButton(context, state),
                    const SizedBox(height: AppTheme.spacingLG),
                  ],
                ),
              ),
            ),
    );
  }

  // ---------------------------------------------------------------------------
  // AppBar
  // ---------------------------------------------------------------------------

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Evacuation Route',
            style: GoogleFonts.inter(
              color: AppTheme.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Shortest safe path — Dijkstra\'s Algorithm',
            style: GoogleFonts.inter(
              color: AppTheme.textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: StatusBanner(status: AlertStatus.evacuationActive),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Severity Banner
  // ---------------------------------------------------------------------------

  Widget _buildSeverityBanner(EmergencyAlert alert) {
    final type = alert.type;
    return AlertBanner(
      message:
          '${type.label.toUpperCase()} ALERT — ${type.description}',
      color: type.color,
      icon: type.icon,
      isActive: true,
    );
  }

  // ---------------------------------------------------------------------------
  // Safe Exit Card
  // ---------------------------------------------------------------------------

  Widget _buildSafeExitCard(RouteResult route) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.safeDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.safeGreen.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppTheme.safeGreen,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SAFE EXIT FOUND',
                      style: GoogleFonts.inter(
                        color: AppTheme.safeGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      route.formattedPath,
                      style: GoogleFonts.inter(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Metrics Row
  // ---------------------------------------------------------------------------

  Widget _buildMetricsRow(RouteResult route) {
    return Row(
      children: [
        Expanded(
          child: _metricCard(
            icon: Icons.straighten_rounded,
            label: 'Distance',
            value: route.formattedDistance,
            color: AppTheme.infoBlue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _metricCard(
            icon: Icons.timer_rounded,
            label: 'Est. Time',
            value: route.formattedTime,
            color: AppTheme.warningAmber,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _metricCard(
            icon: Icons.fork_right_rounded,
            label: 'Waypoints',
            value: '${route.path.length} nodes',
            color: AppTheme.safeGreen,
          ),
        ),
      ],
    );
  }

  Widget _metricCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Nearby Users Card
  // ---------------------------------------------------------------------------

  Widget _buildNearbyUsersCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.warningAmber.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.warningAmber.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.group_rounded,
            color: AppTheme.warningAmber,
            size: 20,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Nearby campus users alerted — evacuation broadcast active',
              style: TextStyle(
                color: AppTheme.warningAmber,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.warningAmber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '● LIVE',
              style: TextStyle(
                color: AppTheme.warningAmber,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Route Visualization (Node-by-Node)
  // ---------------------------------------------------------------------------

  Widget _buildRouteVisualization(RouteResult route) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        children: List.generate(route.pathNames.length, (i) {
          return RouteNodeCard(
            nodeName: route.pathNames[i],
            stepIndex: i,
            isFirst: i == 0,
            isLast: i == route.pathNames.length - 1,
          );
        }),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Algorithm Info Card
  // ---------------------------------------------------------------------------

  Widget _buildAlgorithmInfo(RouteResult route) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.infoBlue.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.infoBlue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.data_object_rounded,
                color: AppTheme.infoBlue,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'DSA — Routing Engine Info',
                style: GoogleFonts.inter(
                  color: AppTheme.infoBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _infoRow('Algorithm', "Dijkstra's Shortest Path"),
          _infoRow('Data Structure', 'Min-Heap Priority Queue'),
          _infoRow('Graph Type', 'Weighted Undirected'),
          _infoRow('Total Weight', '${route.totalWeight.toStringAsFixed(0)} m'),
          _infoRow('Nodes Visited', '${route.path.length} nodes on path'),
        ],
      ),
    );
  }

  Widget _infoRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Recalculate Button
  // ---------------------------------------------------------------------------

  Widget _buildRecalculateButton(BuildContext context, SystemState state) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => state.recalculateRoute(),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.warningAmber,
          side: const BorderSide(color: AppTheme.warningAmber, width: 1),
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.refresh_rounded, size: 18),
        label: Text(
          'RECALCULATE ROUTE',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // No Route State
  // ---------------------------------------------------------------------------

  Widget _buildNoRoute() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.alertRed.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_rounded,
                color: AppTheme.alertRed,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Safe Route Found',
              style: GoogleFonts.inter(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'All exits are currently blocked.\nContact campus emergency services immediately.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: AppTheme.textMuted,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
      ),
    );
  }
}
