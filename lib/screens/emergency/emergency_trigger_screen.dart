import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/campus_node.dart';
import '../../models/emergency_alert.dart';
import '../../state/system_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/emergency_type_card.dart';
import '../route/route_guidance_screen.dart';
import '../status/emergency_status_screen.dart';

/// Emergency Trigger Screen — user confirms emergency type after auto-location.
///
/// Features:
///   - Detected location status card (auto-filled by LocationDetectionScreen)
///   - Emergency type selection cards
///   - Emergency details (description + mock notes field)
///   - Danger level assessment indicator
///   - Trigger SOS Alert button
///
/// The location dropdown has been removed — location is always auto-detected.
class EmergencyTriggerScreen extends StatefulWidget {
  const EmergencyTriggerScreen({super.key});

  @override
  State<EmergencyTriggerScreen> createState() => _EmergencyTriggerScreenState();
}

class _EmergencyTriggerScreenState extends State<EmergencyTriggerScreen> {
  EmergencyType? _selectedType;
  bool _isTriggering = false;

  @override
  Widget build(BuildContext context) {
    final state = SystemStateProvider.of(context);
    final detectedNode = state.detectedLocation;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            // Dynamic type-color banner strip when a type is selected
            if (_selectedType != null) _buildTypeAlertStrip(),
            Expanded(
              child: SingleChildScrollView(
                padding: AppTheme.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Detected location card (replaces manual dropdown) ---
                    if (detectedNode != null) ...[
                      _buildDetectedLocationCard(detectedNode),
                      const SizedBox(height: AppTheme.spacingLG),
                    ],
                    _sectionLabel('SELECT EMERGENCY TYPE'),
                    const SizedBox(height: 12),
                    _buildTypeSelection(),
                    if (_selectedType != null) ...[
                      const SizedBox(height: AppTheme.spacingLG),
                      _sectionLabel('EMERGENCY DETAILS'),
                      const SizedBox(height: 12),
                      _buildEmergencyDetails(),
                      const SizedBox(height: AppTheme.spacingLG),
                      _sectionLabel('DANGER ASSESSMENT'),
                      const SizedBox(height: 12),
                      _buildDangerIndicator(),
                    ],
                    const SizedBox(height: 100), // space for bottom button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildTriggerButton(context, state),
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
            'Confirm Emergency',
            style: GoogleFonts.inter(
              color: AppTheme.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Location detected — select emergency type',
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
          child: Icon(
            Icons.emergency_rounded,
            color: AppTheme.alertRed.withValues(alpha: 0.7),
            size: 22,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Detected Location Card
  // ---------------------------------------------------------------------------

  Widget _buildDetectedLocationCard(CampusNode node) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.safeDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.safeGreen.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on_rounded,
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
                  'CURRENT LOCATION DETECTED',
                  style: GoogleFonts.inter(
                    color: AppTheme.safeGreen,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  node.name,
                  style: GoogleFonts.inter(
                    color: AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          // "Auto" badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.safeGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.safeGreen.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              'AUTO',
              style: GoogleFonts.inter(
                color: AppTheme.safeGreen,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Type Alert Strip
  // ---------------------------------------------------------------------------

  Widget _buildTypeAlertStrip() {
    final type = _selectedType!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: type.color.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(type.icon, color: type.color, size: 15),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${type.label} — ${type.description}',
              style: TextStyle(
                color: type.color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Emergency Type Selection
  // ---------------------------------------------------------------------------

  Widget _buildTypeSelection() {
    return Column(
      children: EmergencyType.values.map((type) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: EmergencyTypeCard(
            type: type,
            isSelected: _selectedType == type,
            onTap: () => setState(() => _selectedType = type),
          ),
        );
      }).toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // Emergency Details
  // ---------------------------------------------------------------------------

  Widget _buildEmergencyDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration(
        borderColor: _selectedType!.color.withValues(alpha: 0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedType!.description,
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          // Mock description input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Row(
              children: [
                const Icon(Icons.notes_rounded, color: AppTheme.textMuted, size: 16),
                const SizedBox(width: 10),
                Text(
                  'Add additional description (optional)...',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Danger Indicator
  // ---------------------------------------------------------------------------

  Widget _buildDangerIndicator() {
    final level = _selectedType!.dangerLevel;
    final color = _selectedType!.color;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Threat Level',
                style: GoogleFonts.inter(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$level / 5',
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Segmented bar
          Row(
            children: List.generate(5, (i) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 6,
                    decoration: BoxDecoration(
                      color: i < level ? color : AppTheme.borderColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Text(
            level >= 4
                ? '⚠️ CRITICAL — Immediate evacuation recommended'
                : level >= 3
                    ? '⚡ HIGH — Evacuation advised'
                    : '🔵 MODERATE — Caution required',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Trigger Button
  // ---------------------------------------------------------------------------

  Widget _buildTriggerButton(BuildContext context, SystemState state) {
    // Can trigger only when an emergency type is selected AND a location is detected
    final canTrigger =
        _selectedType != null && state.detectedLocation != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.borderColor, width: 1)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: canTrigger && !_isTriggering
              ? () => _triggerSOS(context, state)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: canTrigger ? AppTheme.alertRed : AppTheme.surfaceAlt,
            disabledBackgroundColor: AppTheme.surfaceAlt,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: _isTriggering
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.sos_rounded, color: Colors.white, size: 22),
          label: Text(
            _isTriggering ? 'COMPUTING ROUTE...' : 'TRIGGER SOS ALERT',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SOS Trigger Logic
  // ---------------------------------------------------------------------------

  Future<void> _triggerSOS(BuildContext context, SystemState state) async {
    if (_selectedType == null || state.detectedLocation == null) return;

    setState(() => _isTriggering = true);

    // Capture navigator before async gap
    final nav = Navigator.of(context);

    // Navigate to status screen immediately to show processing
    nav.push(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => const EmergencyStatusScreen(),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );

    // Run Dijkstra + state updates
    await state.triggerSOS(
      type: _selectedType!,
      location: state.detectedLocation!,
    );

    if (mounted) setState(() => _isTriggering = false);

    // Auto-navigate to route guidance if route was found
    if (state.currentRoute?.routeFound == true && mounted) {
      nav.push(
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => const RouteGuidanceScreen(),
          transitionsBuilder: (_, animation, __, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    }
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
}
