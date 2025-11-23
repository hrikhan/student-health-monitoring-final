import 'package:flutter/material.dart';

class PulseDisplay extends StatelessWidget {
  const PulseDisplay({
    super.key,
    required this.bpm,
  });

  final int? bpm;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Current BPM',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              bpm != null ? bpm.toString() : '--',
              style: textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
