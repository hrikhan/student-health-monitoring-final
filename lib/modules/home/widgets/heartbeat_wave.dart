import 'dart:math' as math;

import 'package:flutter/material.dart';

class HeartbeatWave extends StatefulWidget {
  const HeartbeatWave({
    super.key,
    required this.bpm,
  });

  final int? bpm;

  @override
  State<HeartbeatWave> createState() => _HeartbeatWaveState();
}

class _HeartbeatWaveState extends State<HeartbeatWave> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _durationForBpm(widget.bpm),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant HeartbeatWave oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bpm != widget.bpm) {
      _controller.duration = _durationForBpm(widget.bpm);
      _controller
        ..reset()
        ..repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _HeartbeatPainter(progress: _controller.value),
          size: Size.infinite,
        );
      },
    );
  }

  Duration _durationForBpm(int? bpm) {
    final safeBpm = bpm != null && bpm > 30 && bpm < 200 ? bpm : 72;
    // Slow further: effectively halve BPM speed.
    final ms = (60000 / safeBpm * 2).clamp(800, 4000).toInt();
    return Duration(milliseconds: ms);
  }
}

class _HeartbeatPainter extends CustomPainter {
  _HeartbeatPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = const Color(0xFF0E1C1B)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Draw grid
    final gridPaint = Paint()
      ..color = const Color(0xFF1F3D3B)
      ..strokeWidth = 1;
    const gridSize = 16.0;
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final path = Path();
    final midY = size.height * 0.6;
    final amplitude = size.height * 0.25;
    final step = size.width / 40;
    final shift = progress * size.width;

    for (double x = -shift; x <= size.width + step; x += step) {
      final t = (x + shift) / size.width;
      final mod = (t * 6) % 1;
      double y = midY;

      if (mod > 0.05 && mod < 0.08) {
        y = midY - amplitude * 0.2;
      } else if (mod >= 0.08 && mod < 0.1) {
        y = midY + amplitude * 0.15;
      } else if (mod >= 0.1 && mod < 0.12) {
        y = midY - amplitude;
      } else if (mod >= 0.12 && mod < 0.14) {
        y = midY + amplitude * 0.3;
      } else if (mod >= 0.14 && mod < 0.16) {
        y = midY - amplitude * 0.15;
      } else {
        y = midY + math.sin(t * 12 * math.pi) * amplitude * 0.02;
      }

      if (x == -shift) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final linePaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF00FF9D),
          Color(0xFF00E676),
          Color(0xFF00C853),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Offset.zero & size)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    // Moving pulse
    final pulseX = (size.width * progress) % size.width;
    final pulseY = midY - amplitude * 0.05;
    final glowPaint = Paint()
      ..color = const Color(0xFF00FF9D).withOpacity(0.7)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset(pulseX, pulseY), 6, glowPaint);
    canvas.drawCircle(Offset(pulseX, pulseY), 3, Paint()..color = const Color(0xFF00FF9D));
  }

  @override
  bool shouldRepaint(covariant _HeartbeatPainter oldDelegate) => oldDelegate.progress != progress;
}
