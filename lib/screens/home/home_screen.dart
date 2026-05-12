import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/emergency_alert.dart';

import '../../theme/app_theme.dart';
import '../../widgets/sos_button.dart';
import '../../widgets/emergency_type_card.dart';
import '../../widgets/status_banner.dart';
import '../emergency/emergency_trigger_screen.dart';

/// Home Screen — main landing screen for emergency access.
///
/// Features:
///   - App header with system status
///   - Emergency warning banner
///   - Large pulsing SOS button
///   - Quick emergency type shortcuts
///   - System readiness indicator
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: AppTheme.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWarningBanner(),
                    const SizedBox(height: AppTheme.spacingXL),
                    _buildSOSSection(context),
                    const SizedBox(height: AppTheme.spacingXL),
                    _buildQuickEmergencySection(context),
                    const SizedBox(height: AppTheme.spacingLG),
                    _buildSystemStatus(),
                    const SizedBox(height: AppTheme.spacingLG),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Logo icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.alertRed.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.emergency_share_rounded,
              color: AppTheme.alertRed,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EARS',
                  style: GoogleFonts.inter(
                    color: AppTheme.alertRed,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 3,
                  ),
                ),
                Text(
                  'Emergency Alert Routing System',
                  style: GoogleFonts.inter(
                    color: AppTheme.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // System ready indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.safeGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.safeGreen.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.safeGreen,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  'READY',
                  style: GoogleFonts.inter(
                    color: AppTheme.safeGreen,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Warning Banner
  // ---------------------------------------------------------------------------

  Widget _buildWarningBanner() {
    return AlertBanner(
      message:
          'Campus Emergency Routing Active — System Ready for Deployment',
      color: AppTheme.warningAmber,
      icon: Icons.warning_amber_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // SOS Section
  // ---------------------------------------------------------------------------

  Widget _buildSOSSection(BuildContext context) {
    return Column(
      children: [
        Center(
          child: SosButton(
            onPressed: () => _navigateToEmergency(context, null),
            size: 170,
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(
            'Press SOS to trigger emergency alert\nand get evacuation route instantly',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Quick Emergency Selection
  // ---------------------------------------------------------------------------

  Widget _buildQuickEmergencySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('QUICK EMERGENCY'),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.35,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: EmergencyType.values
              .map(
                (type) => EmergencyTypeCard(
                  type: type,
                  compact: true,
                  onTap: () => _navigateToEmergency(context, type),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // System Status Footer
  // ---------------------------------------------------------------------------

  Widget _buildSystemStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('SYSTEM STATUS'),
          const SizedBox(height: 14),
          _statusRow(
            Icons.account_tree_rounded,
            'Campus Graph',
            '12 nodes · 20 edges loaded',
            AppTheme.safeGreen,
          ),
          const SizedBox(height: 10),
          _statusRow(
            Icons.route_rounded,
            'Routing Engine',
            'Dijkstra\'s Algorithm — Active',
            AppTheme.safeGreen,
          ),
          const SizedBox(height: 10),
          _statusRow(
            Icons.exit_to_app_rounded,
            'Safe Exits',
            'Main Gate · Back Gate · Sports Ground',
            AppTheme.infoBlue,
          ),
          const SizedBox(height: 10),
          _statusRow(
            Icons.queue_rounded,
            'Alert Queue',
            'Ready · 0 pending alerts',
            AppTheme.safeGreen,
          ),
        ],
      ),
    );
  }

  Widget _statusRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w600,
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

  void _navigateToEmergency(BuildContext context, EmergencyType? preselected) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => EmergencyTriggerScreen(
          preselectedType: preselected,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }
}
