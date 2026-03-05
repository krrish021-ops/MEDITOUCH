import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Splash screen — animated gradient background (blue → pink),
/// pulsing glow logo, and fade-in tagline before navigating onward.
class SplashScreen extends StatefulWidget {
  final VoidCallback onFinished;
  const SplashScreen({super.key, required this.onFinished});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final AnimationController _fadeCtrl;
  late final Animation<double> _pulse;
  late final Animation<double> _fade;
  late final AnimationController _gradCtrl;

  @override
  void initState() {
    super.initState();

    // Gradient shift
    _gradCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Pulsing glow on logo
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulse = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    // Fade-in text
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _fadeCtrl.forward();
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) widget.onFinished();
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _fadeCtrl.dispose();
    _gradCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _gradCtrl,
      builder: (context, child) {
        final t = _gradCtrl.value;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(
                math.cos(t * 2 * math.pi),
                math.sin(t * 2 * math.pi),
              ),
              end: Alignment(
                -math.cos(t * 2 * math.pi),
                -math.sin(t * 2 * math.pi),
              ),
              colors: const [
                AppTheme.electricBlue,
                AppTheme.bgPrimary,
                AppTheme.radiantPink,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: child,
        );
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pulsing glow ring + icon
              AnimatedBuilder(
                animation: _pulse,
                builder: (context, child) {
                  return Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.electricBlue.withValues(
                            alpha: 0.5 * _pulse.value,
                          ),
                          blurRadius: 40 * _pulse.value,
                          spreadRadius: 8 * _pulse.value,
                        ),
                      ],
                    ),
                    child: child,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.accentGradient,
                  ),
                  child: const Icon(
                    Icons.health_and_safety,
                    size: 54,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FadeTransition(
                opacity: _fade,
                child: Column(
                  children: [
                    Text(
                      'MEDITOUCH',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineLarge?.copyWith(
                        letterSpacing: 6,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your Digital Health Guardian',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
