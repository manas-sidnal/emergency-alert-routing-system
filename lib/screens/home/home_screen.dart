import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../widgets/sos_button.dart';
import '../location/location_detection_screen.dart';

/// Home Screen — distraction-free emergency landing screen.
///
/// Features:
///   - App header with live system status badge
///   - Large centered pulsing SOS button (primary focus)
///   - Concise operational system status section
///
/// Design intent: Every element is optimized for emergency situations.
/// The user should press SOS within 2 seconds of opening the app.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: AppTheme.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppTheme.spacingMD),
                    _buildSOSSection(context),
                    const SizedBox(height: AppTheme.spacingXL),
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

  Widget _buildHeader() {
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
              color: AppTheme.alertRed.withValues(alpha: 0.15),
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
          // Live system ready indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.safeGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.safeGreen.withValues(alpha: 0.3),
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
  // SOS Section — primary focus of the screen
  // ---------------------------------------------------------------------------

  Widget _buildSOSSection(BuildContext context) {
    return Column(
      children: [
        // Subtitle above button
        Center(
          child: Text(
            'CAMPUS EMERGENCY',
            style: GoogleFonts.inter(
              color: AppTheme.alertRed.withValues(alpha: 0.7),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 3,
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingXL),
        // Large SOS button — the hero element
        Center(
          child: SosButton(
            onPressed: () => _onSOSPressed(context),
            size: 180,
          ),
        ),
        const SizedBox(height: AppTheme.spacingLG),
        // Helper text
        Center(
          child: Text(
            'Press SOS — system will auto-detect\nyour campus location and generate\nthe fastest evacuation route.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 13,
              height: 1.7,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // System Status — clean operational display
  // ---------------------------------------------------------------------------

  Widget _buildSystemStatus() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section label
          Text(
            'SYSTEM STATUS',
            style: GoogleFonts.inter(
              color: AppTheme.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          // Operational status items
          _statusItem(Icons.route_rounded,          'Routing Engine Active'),
          _statusItem(Icons.exit_to_app_rounded,    'Safe Exits Available'),
          _statusItem(Icons.wifi_tethering_rounded, 'Emergency Network Ready'),
          _statusItem(Icons.queue_rounded,          'Alert Queue Operational'),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),
          // Subtle DSA footer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.data_object_rounded,
                color: AppTheme.textMuted,
                size: 12,
              ),
              const SizedBox(width: 6),
              Text(
                "Powered by Dijkstra's Shortest Path Algorithm",
                style: GoogleFonts.inter(
                  color: AppTheme.textMuted,
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// A single status row with a green dot indicator.
  Widget _statusItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Green dot
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.safeGreen,
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, color: AppTheme.textSecondary, size: 15),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  /// Navigates to the location detection loading screen.
  /// The SOS flow: Home → LocationDetection → EmergencyTrigger → Status → Route
  void _onSOSPressed(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => const LocationDetectionScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
