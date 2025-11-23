import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/screen_utils.dart';

class BpmCard extends StatelessWidget {
  const BpmCard({
    super.key,
    required this.bpm,
    required this.isConnected,
    required this.statusText,
  });

  final int? bpm;
  final bool isConnected;
  final String statusText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bpmText = bpm != null ? bpm.toString() : '--';
    final bpmFontSize = ScreenUtils.responsiveFont(context, base: 72, min: 52, max: 76);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              statusText,
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            Icon(
              isConnected ? Icons.show_chart : Icons.ssid_chart,
              color: isConnected ? Colors.white : Colors.white54,
              size: 28,
            ),
          ],
        ),
        const SizedBox(height: 16),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            bpmText,
            style: theme.textTheme.displayLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: bpmFontSize,
            ),
          ),
        ),
        Text(
          'current_bpm'.tr,
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white70,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
