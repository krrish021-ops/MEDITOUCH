import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Animated gradient background with floating glowing orbs that drift slowly,
/// giving a deep-space / futuristic health-tech vibe.
class NebulaBackground extends StatefulWidget {
  final Widget child;
  const NebulaBackground({super.key, required this.child});

  @override
  State<NebulaBackground> createState() => _NebulaBackgroundState();
}

class _NebulaBackgroundState extends State<NebulaBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final t = _ctrl.value;
        return Container(
          decoration: AppTheme.scaffoldGradient,
          child: Stack(
            children: [
              // Floating orb 1 – Electric Blue
              Positioned(
                top: 80 + 30 * math.sin(t * 2 * math.pi),
                right: 30 + 20 * math.cos(t * 2 * math.pi),
                child: _orb(100, AppTheme.electricBlue.withValues(alpha: 0.07)),
              ),
              // Floating orb 2 – Radiant Pink
              Positioned(
                bottom: 200 + 40 * math.cos(t * 2 * math.pi + 1),
                left: 20 + 25 * math.sin(t * 2 * math.pi + 1),
                child: _orb(140, AppTheme.radiantPink.withValues(alpha: 0.06)),
              ),
              // Floating orb 3 – Neon Green
              Positioned(
                top:
                    MediaQuery.of(context).size.height * 0.45 +
                    20 * math.sin(t * 2 * math.pi + 2),
                right: 60 + 30 * math.cos(t * 2 * math.pi + 2),
                child: _orb(80, AppTheme.neonGreen.withValues(alpha: 0.05)),
              ),
              child!,
            ],
          ),
        );
      },
      child: widget.child,
    );
  }

  Widget _orb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }
}
