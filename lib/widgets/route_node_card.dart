import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Displays a single step/node in the evacuation route as a visual card.
///
/// Shows the node name, step index, and a connection line to the next node.
class RouteNodeCard extends StatelessWidget {
  final String nodeName;
  final int stepIndex;
  final bool isFirst;
  final bool isLast;
  final bool isCurrent;

  const RouteNodeCard({
    super.key,
    required this.nodeName,
    required this.stepIndex,
    this.isFirst = false,
    this.isLast = false,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    final nodeColor = isLast
        ? AppTheme.safeGreen
        : isFirst
            ? AppTheme.alertRed
            : AppTheme.infoBlue;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column: step indicator + connector line
        Column(
          children: [
            // Circle indicator
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: nodeColor.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: nodeColor, width: 2),
              ),
              alignment: Alignment.center,
              child: isLast
                  ? Icon(Icons.flag_rounded, color: nodeColor, size: 16)
                  : isFirst
                      ? Icon(Icons.person_pin_circle_rounded,
                          color: nodeColor, size: 16)
                      : Text(
                          '$stepIndex',
                          style: TextStyle(
                            color: nodeColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
            ),
            // Connector line
            if (!isLast)
              Container(
                width: 2,
                height: 32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [nodeColor, AppTheme.infoBlue.withOpacity(0.5)],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 14),
        // Right: node info
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nodeName,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: isFirst || isLast
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isFirst
                      ? 'Starting point'
                      : isLast
                          ? 'Safe exit'
                          : 'Continue through',
                  style: TextStyle(
                    color: nodeColor.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
