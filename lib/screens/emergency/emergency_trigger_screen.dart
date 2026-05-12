import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/campus_node.dart';
import '../../models/emergency_alert.dart';
import '../../state/system_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/emergency_type_card.dart';
import '../../core/mock_campus_data.dart';
import '../route/route_guidance_screen.dart';
import '../status/emergency_status_screen.dart';

/// Emergency Trigger Screen — user selects emergency type and location.
///
/// Features:
///   - Emergency type selection cards (full layout)
///   - Campus location dropdown
///   - Danger level indicator
///   - Emergency description field (mock)
///   - Trigger SOS Alert button
class EmergencyTriggerScreen extends StatefulWidget {
  final EmergencyType? preselectedType;

  const EmergencyTriggerScreen({
    super.key,
    this.preselectedType,
  });

  @override
  State<EmergencyTriggerScreen> createState() =>
      _EmergencyTriggerScreenState();
}

class _EmergencyTriggerScreenState extends State<EmergencyTriggerScreen> {
  EmergencyType? _selectedType;
  CampusNode? _selectedLocation;
  bool _isTriggering = false;

  final List<CampusNode> _locations = MockCampusData.selectableLocations;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.preselectedType;
    _selectedLocation = _locations.first;
  }

  @override
  Widget build(BuildContext context) {
    final state = SystemStateProvider.of(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            // Top alert strip
            if (_selectedType != null) _buildTypeAlertStrip(),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: AppTheme.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel('SELECT EMERGENCY TYPE'),
                    const SizedBox(height: 12),
                    _buildTypeSelection(),
                    const SizedBox(height: AppTheme.spacingLG),
                    _sectionLabel('CURRENT CAMPUS LOCATION'),
                    const SizedBox(height: 12),
                    _buildLocationDropdown(),
                    const SizedBox(height: AppTheme.spacingLG),
                    if (_selectedType != null) ...[
                      _sectionLabel('EMERGENCY DETAILS'),
                      const SizedBox(height: 12),
                      _buildEmergencyDetails(),
                      const SizedBox(height: AppTheme.spacingLG),
                      _sectionLabel('DANGER ASSESSMENT'),
                      const SizedBox(height: 12),
                      _buildDangerIndicator(),
                      const SizedBox(height: AppTheme.spacingXL),
                    ],
                    const SizedBox(height: 80), // space for button
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
            'Trigger Emergency',
            style: GoogleFonts.inter(
              color: AppTheme.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Configure and activate SOS alert',
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
            color: AppTheme.alertRed.withOpacity(0.7),
            size: 22,
          ),
        ),
      ],
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
      color: type.color.withOpacity(0.1),
      child: Row(
        children: [
          Icon(type.icon, color: type.color, size: 16),
          const SizedBox(width: 8),
          Text(
            '${type.label} emergency selected — ${type.description}',
            style: TextStyle(
              color: type.color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
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
  // Location Dropdown
  // ---------------------------------------------------------------------------

  Widget _buildLocationDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: AppTheme.cardDecoration(),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CampusNode>(
          value: _selectedLocation,
          isExpanded: true,
          dropdownColor: AppTheme.surfaceAlt,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppTheme.textSecondary,
          ),
          style: GoogleFonts.inter(
            color: AppTheme.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          items: _locations.map((node) {
            return DropdownMenuItem<CampusNode>(
              value: node,
              child: Row(
                children: [
                  Icon(
                    _nodeIcon(node.type),
                    color: AppTheme.infoBlue,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(node.name),
                ],
              ),
            );
          }).toList(),
          onChanged: (node) => setState(() => _selectedLocation = node),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Emergency Details
  // ---------------------------------------------------------------------------

  Widget _buildEmergencyDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration(
        borderColor: _selectedType!.color.withOpacity(0.3),
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
          // Mock description field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.notes_rounded,
                  color: AppTheme.textMuted,
                  size: 16,
                ),
                const SizedBox(width: 10),
                Text(
                  'Add additional description (optional)...',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 13,
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
          Row(
            children: List.generate(5, (i) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 6,
                    decoration: BoxDecoration(
                      color: i < level
                          ? color
                          : AppTheme.borderColor,
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
    final canTrigger = _selectedType != null && _selectedLocation != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: const Border(
          top: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: ElevatedButton.icon(
            onPressed: canTrigger && !_isTriggering
                ? () => _triggerSOS(context, state)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  canTrigger ? AppTheme.alertRed : AppTheme.surfaceAlt,
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
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SOS Trigger Logic
  // ---------------------------------------------------------------------------

  Future<void> _triggerSOS(BuildContext context, SystemState state) async {
    if (_selectedType == null || _selectedLocation == null) return;

    setState(() => _isTriggering = true);

    // Capture navigator before any async gap
    final nav = Navigator.of(context);

    // Navigate to status screen immediately
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
      location: _selectedLocation!,
    );

    if (mounted) setState(() => _isTriggering = false);

    // Navigate to route guidance if route found
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

  IconData _nodeIcon(NodeType type) {
    switch (type) {
      case NodeType.building:
        return Icons.business_rounded;
      case NodeType.exit:
        return Icons.exit_to_app_rounded;
      case NodeType.hostel:
        return Icons.hotel_rounded;
      case NodeType.medical:
        return Icons.local_hospital_rounded;
      case NodeType.parking:
        return Icons.local_parking_rounded;
      case NodeType.gate:
        return Icons.sensor_door_rounded;
    }
  }
}
