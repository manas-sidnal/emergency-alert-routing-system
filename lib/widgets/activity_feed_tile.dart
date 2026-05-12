import 'package:flutter/material.dart';
import '../state/system_state.dart';
import '../theme/app_theme.dart';

/// A single tile in the activity feed on the Emergency Status screen.
///
/// Shows an emoji prefix message and a timestamp.
class ActivityFeedTile extends StatelessWidget {
  final ActivityEvent event;
  final bool isLatest;

  const ActivityFeedTile({
    super.key,
    required this.event,
    this.isLatest = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isLatest
            ? AppTheme.infoBlue.withOpacity(0.08)
            : AppTheme.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLatest
              ? AppTheme.infoBlue.withOpacity(0.3)
              : AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vertical accent line
          Container(
            width: 3,
            height: 34,
            decoration: BoxDecoration(
              color: isLatest ? AppTheme.infoBlue : AppTheme.mutedGray,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.message,
                  style: TextStyle(
                    color: isLatest
                        ? AppTheme.textPrimary
                        : AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight:
                        isLatest ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  event.timeLabel,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
