import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/emergency_alert.dart';
import '../../state/system_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/activity_feed_tile.dart';
import '../../widgets/status_banner.dart';
import '../route/route_guidance_screen.dart';

/// Emergency Status Screen — shows real-time processing state and activity log.
///
/// Features:
///   - Alert status progress pipeline (Pending → Processing → Route Generated → Evacuation Active)
///   - Live activity feed with timestamped events
///   - Route recalculation section
///   - Resolve emergency action
class EmergencyStatusScreen extends StatelessWidget {
  const EmergencyStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SystemStateProvider.of(context),
      builder: (context, _) {
        final state = SystemStateProvider.of(context);
        final alert = state.activeAlert;

        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: _buildAppBar(context, state),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: AppTheme.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (alert != null) _buildAlertHeader(alert, state),
                  const SizedBox(height: AppTheme.spacingMD),
                  _buildStatusPipeline(state.currentStatus),
                  const SizedBox(height: AppTheme.spacingLG),
                  if (state.currentRoute?.routeFound == true) ...[
                    _buildRouteCard(context, state),
                    const SizedBox(height: AppTheme.spacingLG),
                  ],
                  _sectionLabel('LIVE ACTIVITY FEED'),
                  const SizedBox(height: 12),
                  _buildActivityFeed(state),
                  const SizedBox(height: AppTheme.spacingLG),
                  _buildActionButtons(context, state),
                  const SizedBox(height: AppTheme.spacingLG),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // AppBar
  // ---------------------------------------------------------------------------

  AppBar _buildAppBar(BuildContext context, SystemState state) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emergency Status',
            style: GoogleFonts.inter(
              color: AppTheme.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Alert processing & evacuation tracking',
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
          child: StatusBanner(status: state.currentStatus),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Alert Header
  // ---------------------------------------------------------------------------

  Widget _buildAlertHeader(EmergencyAlert alert, SystemState state) {
    final type = alert.type;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.alertDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: type.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(type.icon, color: type.color, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${type.label} Emergency',
                  style: GoogleFonts.inter(
                    color: AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: ${alert.id}',
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Triggered: ${_formatTime(alert.timestamp)}',
                  style: GoogleFonts.inter(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          StatusBanner(status: state.currentStatus, large: true),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Status Pipeline
  // ---------------------------------------------------------------------------

  Widget _buildStatusPipeline(AlertStatus current) {
    final stages = [
      AlertStatus.pending,
      AlertStatus.processing,
      AlertStatus.routeGenerated,
      AlertStatus.evacuationActive,
    ];

    final currentIndex = stages.indexOf(current);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('ALERT PIPELINE'),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: AppTheme.cardDecoration(),
          child: Row(
            children: List.generate(stages.length * 2 - 1, (i) {
              if (i.isOdd) {
                // Connector line
                final passed = (i ~/ 2) < currentIndex;
                return Expanded(
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: passed
                          ? AppTheme.safeGreen
                          : AppTheme.borderColor,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                );
              }

              final stageIndex = i ~/ 2;
              final stage = stages[stageIndex];
              final isActive = stageIndex == currentIndex;
              final isPassed = stageIndex < currentIndex;
              final color = isPassed || isActive
                  ? stage.color
                  : AppTheme.mutedGray;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isPassed || isActive
                          ? color.withOpacity(0.15)
                          : AppTheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: color,
                        width: isActive ? 2 : 1,
                      ),
                    ),
                    child: Icon(
                      isPassed
                          ? Icons.check_rounded
                          : stage.icon,
                      color: color,
                      size: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 60,
                    child: Text(
                      stage.label,
                      style: TextStyle(
                        color: isActive ? color : AppTheme.textMuted,
                        fontSize: 9,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w400,
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Route Card
  // ---------------------------------------------------------------------------

  Widget _buildRouteCard(BuildContext context, SystemState state) {
    final route = state.currentRoute!;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, a, __) => const RouteGuidanceScreen(),
          transitionsBuilder: (_, a, __, child) => FadeTransition(
            opacity: a,
            child: child,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.safeDecoration(),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.safeGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.alt_route_rounded,
                color: AppTheme.safeGreen,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Evacuation Route Ready',
                    style: GoogleFonts.inter(
                      color: AppTheme.safeGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    route.formattedPath,
                    style: GoogleFonts.inter(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View',
                  style: TextStyle(
                    color: AppTheme.safeGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.safeGreen,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Activity Feed
  // ---------------------------------------------------------------------------

  Widget _buildActivityFeed(SystemState state) {
    final events = state.activityFeed;

    if (events.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: AppTheme.cardDecoration(),
        child: Center(
          child: Text(
            'No activity yet.\nTrigger an SOS alert to begin.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppTheme.textMuted,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),
      );
    }

    return Column(
      children: events.asMap().entries.map((e) {
        return ActivityFeedTile(
          event: e.value,
          isLatest: e.key == 0,
        );
      }).toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // Action Buttons
  // ---------------------------------------------------------------------------

  Widget _buildActionButtons(BuildContext context, SystemState state) {
    return Column(
      children: [
        if (state.emergencyActive &&
            state.currentStatus != AlertStatus.resolved) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                state.resolveEmergency();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.safeGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.check_circle_rounded, color: Colors.black),
              label: Text(
                'RESOLVE EMERGENCY',
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              state.resetState();
              Navigator.of(context).popUntil((r) => r.isFirst);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.textSecondary,
              side: const BorderSide(color: AppTheme.borderColor),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.home_rounded, size: 18),
            label: Text(
              'RETURN TO HOME',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

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

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}:'
        '${dt.second.toString().padLeft(2, '0')}';
  }
}
