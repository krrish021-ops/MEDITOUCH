import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable avatar widget that displays the user's DiceBear profile picture
/// with a gradient border and glow, falling back to initial letter.
class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double radius;
  final bool showGlow;
  final Gradient? borderGradient;

  const UserAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.radius = 44,
    this.showGlow = true,
    this.borderGradient,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = borderGradient ?? AppTheme.accentGradient;
    final letter = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: gradient,
        boxShadow:
            showGlow
                ? AppTheme.glow(
                  AppTheme.electricBlue,
                  blur: radius * 0.4,
                  spread: 1,
                )
                : null,
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: AppTheme.bgPrimary,
        backgroundImage:
            imageUrl != null && imageUrl!.isNotEmpty
                ? NetworkImage(imageUrl!)
                : null,
        child:
            imageUrl == null || imageUrl!.isEmpty
                ? Text(
                  letter,
                  style: TextStyle(
                    fontSize: radius * 0.75,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.electricBlue,
                  ),
                )
                : null,
      ),
    );
  }
}
