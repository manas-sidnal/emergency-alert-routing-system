import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_campus_data.dart';
import '../../models/campus_node.dart';
import '../../state/system_state.dart';
import '../../theme/app_theme.dart';
import '../emergency/emergency_trigger_screen.dart';

/// Location Detection Screen — intermediate loading screen shown after SOS press.
///
/// Simulates automatic GPS-based location detection and nearest campus-node mapping.
/// All logic is mocked — no real GPS or APIs are used.
///
/// Workflow:
///   1. "Acquiring GPS signal..." (animated)
///   2. "Detecting your campus location..." (animated)
///   3. "Mapping to nearest campus node..." (animated)
///   4. Auto-navigate → EmergencyTriggerScreen with detected node pre-filled
class LocationDetectionScreen extends StatefulWidget {
  const LocationDetectionScreen({super.key});

  @override
  State<LocationDetectionScreen> createState() =>
      _LocationDetectionScreenState();
}

class _LocationDetectionScreenState extends State<LocationDetectionScreen>
    with TickerProviderStateMixin {
  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  int _step = 0; // 0 = GPS, 1 = campus detection, 2 = node mapping, 3 = done

  /// The steps shown to the user in sequence.
  static const List<_DetectionStep> _steps = [
    _DetectionStep(
      icon: Icons.gps_fixed_rounded,
      label: 'Acquiring GPS signal...',
      sublabel: 'Connecting to campus positioning system',
      color: AppTheme.infoBlue,
    ),
    _DetectionStep(
      icon: Icons.location_searching_rounded,
      label: 'Detecting your campus location...',
      sublabel: 'Triangulating position on campus map',
      color: AppTheme.warningAmber,
    ),
    _DetectionStep(
      icon: Icons.account_tree_rounded,
      label: 'Mapping to nearest campus node...',
      sublabel: 'Running proximity matching algorithm',
      color: AppTheme.alertRed,
    ),
  ];

  /// Mock detected node — randomly picked from selectable locations.
  late final CampusNode _detectedNode;

  // Animations
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnim;
  late Animation<double> _fadeAnim;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    // Pick a random campus location to simulate GPS detection
    final locations = MockCampusData.selectableLocations;
    _detectedNode = locations[Random().nextInt(locations.length)];

    // Pulse animation for the radar circle
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.88, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Fade animation for step transitions
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();

    // Start the sequential detection simulation
    _runDetectionSequence();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Detection Sequence (mock/simulated)
  // ---------------------------------------------------------------------------

  Future<void> _runDetectionSequence() async {
    // Step 0 — GPS signal
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    await _advanceTo(1);

    // Step 1 — Campus location detection
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    await _advanceTo(2);

    // Step 2 — Node mapping
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _step = 3); // Mark as done

    // Brief pause to show "Location Detected" before navigating
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    _navigateToTrigger();
  }

  Future<void> _advanceTo(int step) async {
    _fadeController.reset();
    setState(() => _step = step);
    _fadeController.forward();
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  void _navigateToTrigger() {
    // Store detected location in system state
    SystemStateProvider.of(context).setDetectedLocation(_detectedNode);

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => const EmergencyTriggerScreen(),
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
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

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 60),
              _buildTopBar(),
              const Spacer(),
              _buildRadarAnimation(),
              const SizedBox(height: 48),
              _buildStepInfo(),
              const SizedBox(height: 40),
              _buildStepIndicators(),
              const Spacer(flex: 2),
              if (_step == 3) _buildDetectedCard(),
              if (_step == 3) const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Top Bar
  // ---------------------------------------------------------------------------

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: AppTheme.alertRed.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.alertRed.withValues(alpha: 0.35),
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
                  color: AppTheme.alertRed,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                'SOS ACTIVATED',
                style: GoogleFonts.inter(
                  color: AppTheme.alertRed,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Radar Animation
  // ---------------------------------------------------------------------------

  Widget _buildRadarAnimation() {
    final currentStep = _step < _steps.length ? _steps[_step] : _steps.last;
    final color = _step == 3 ? AppTheme.safeGreen : currentStep.color;

    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, __) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring
            Transform.scale(
              scale: _pulseAnim.value,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color.withValues(alpha: 0.15),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            // Mid ring
            Transform.scale(
              scale: _pulseAnim.value * 0.92,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            // Inner filled circle
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.1),
                border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
              ),
              child: _step == 3
                  ? const Icon(
                      Icons.check_circle_rounded,
                      color: AppTheme.safeGreen,
                      size: 42,
                    )
                  : Icon(
                      currentStep.icon,
                      color: color,
                      size: 38,
                    ),
            ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Step Info Text
  // ---------------------------------------------------------------------------

  Widget _buildStepInfo() {
    final isDone = _step == 3;
    final label = isDone ? 'Location Detected' : _steps[_step].label;
    final sub = isDone
        ? 'Navigating to emergency configuration...'
        : _steps[_step].sublabel;
    final color =
        isDone ? AppTheme.safeGreen : _steps[_step < _steps.length ? _step : _steps.length - 1].color;

    return FadeTransition(
      opacity: _fadeAnim,
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            sub,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          // Loading bar
          if (!isDone)
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: AppTheme.borderColor,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                borderRadius: BorderRadius.circular(4),
                minHeight: 3,
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step Dot Indicators
  // ---------------------------------------------------------------------------

  Widget _buildStepIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_steps.length, (i) {
        final isActive = i == _step;
        final isPassed = i < _step;
        final color = isPassed || isActive
            ? _steps[i].color
            : AppTheme.borderColor;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  // ---------------------------------------------------------------------------
  // Detected Location Card (shown when done)
  // ---------------------------------------------------------------------------

  Widget _buildDetectedCard() {
    return AnimatedOpacity(
      opacity: _step == 3 ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 400),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.safeDecoration(),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.safeGreen.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.location_on_rounded,
                color: AppTheme.safeGreen,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Location Detected',
                  style: GoogleFonts.inter(
                    color: AppTheme.safeGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _detectedNode.name,
                  style: GoogleFonts.inter(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Data class for each detection step.
class _DetectionStep {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;

  const _DetectionStep({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
  });
}
