import 'dart:ui';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Builds climate resilience score card with high-fidelity visualization
Widget buildClimateResilienceCard({Map<String, dynamic>? data}) {
  final windSpeed = data?['wind_speed'] ?? '15-20 km/hr';

  return ClipRRect(
    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor.withValues(alpha: 0.9),
              AppColors.primaryColor.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.2),
              blurRadius: AppSizes.md,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Circular progress indicator with custom neon feel
            const SizedBox(
              width: 72,
              height: 72,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CustomPaint(
                    painter: CircularProgressPainter(
                      progress: 0.85,
                      color: AppColors.neonGreen,
                      thickness: 6,
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '8.5',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppSizes.fontTitle + 2,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                        ),
                        Text(
                          'SCORE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 7,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.lg),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Climate Resilience',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppSizes.fontTitle,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  _buildResilienceBadge(
                    icon: Icons.air_rounded,
                    label: 'Wind: $windSpeed',
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: AppSizes.xs),
                  _buildResilienceBadge(
                    icon: Icons.shield_rounded,
                    label: 'High Drought Tolerance',
                    color: AppColors.neonGreen,
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

Widget _buildResilienceBadge({
  required IconData icon,
  required String label,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSizes.sm,
      vertical: AppSizes.xs,
    ),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.1),
        width: 0.5,
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: AppSizes.iconSm),
        const SizedBox(width: AppSizes.sm),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: AppSizes.fontCaption,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double thickness;

  const CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.thickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - thickness) / 2;

    final basePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, basePaint);

    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708, // -90 degrees in radians
      6.28319 * progress, // 360 degrees in radians * progress
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
