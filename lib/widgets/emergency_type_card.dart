import 'package:flutter/material.dart';
import '../models/emergency_alert.dart';
import '../theme/app_theme.dart';

/// A selectable card representing an emergency type.
///
/// Used on the Home screen (quick shortcuts) and Emergency Trigger screen.
class EmergencyTypeCard extends StatelessWidget {
  final EmergencyType type;
  final bool isSelected;
  final VoidCallback onTap;
  final bool compact;

  const EmergencyTypeCard({
    super.key,
    required this.type,
    required this.onTap,
    this.isSelected = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = type.color;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.all(compact ? 12 : 16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.15)
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : AppTheme.borderColor,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: compact
            ? _CompactContent(type: type, color: color, isSelected: isSelected)
            : _FullContent(type: type, color: color, isSelected: isSelected),
      ),
    );
  }
}

class _CompactContent extends StatelessWidget {
  final EmergencyType type;
  final Color color;
  final bool isSelected;

  const _CompactContent({
    required this.type,
    required this.color,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(type.icon, color: color, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          type.label,
          style: TextStyle(
            color: isSelected ? color : AppTheme.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FullContent extends StatelessWidget {
  final EmergencyType type;
  final Color color;
  final bool isSelected;

  const _FullContent({
    required this.type,
    required this.color,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(type.icon, color: color, size: 26),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type.label,
                style: TextStyle(
                  color: isSelected ? color : AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Danger Level: ${'●' * type.dangerLevel}${'○' * (5 - type.dangerLevel)}',
                style: TextStyle(
                  color: color.withOpacity(0.8),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
        if (isSelected)
          Icon(Icons.check_circle_rounded, color: color, size: 20),
      ],
    );
  }
}
