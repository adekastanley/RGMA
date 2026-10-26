import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Signature pill button combining the Pinterest reference shape with
/// Rhema Gold (`#E5A93C`) and a Deep Navy (`#132238`) circular icon badge.
class NeonPillButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isCompact;
  final Color? backgroundColor;
  final Color? textColor;

  const NeonPillButton({
    super.key,
    required this.label,
    this.icon = Icons.arrow_forward_rounded,
    required this.onTap,
    this.isCompact = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.rhemaGold;
    final fg = textColor ?? AppColors.rhemaNavy;
    final height = isCompact ? 42.0 : 52.0;
    final circleSize = isCompact ? 32.0 : 40.0;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(height / 2),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(height / 2),
        child: Container(
          height: height,
          padding: EdgeInsets.only(
            left: (height - circleSize) / 2,
            right: isCompact ? 16 : 22,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: circleSize,
                height: circleSize,
                decoration: const BoxDecoration(
                  color: AppColors.rhemaNavy,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: isCompact ? 16 : 19,
                ),
              ),
              SizedBox(width: isCompact ? 10 : 12),
              Text(
                label,
                style: TextStyle(
                  color: fg,
                  fontSize: isCompact ? 13 : 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Circular icon button used in top app bars (Back, Search, Notifications, Download).
class DarkCircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool showBadge;
  final Color? iconColor;
  final double size;

  const DarkCircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.showBadge = false,
    this.iconColor,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(
        side: BorderSide(color: AppColors.border, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                color: iconColor ?? AppColors.rhemaNavy,
                size: size * 0.46,
              ),
              if (showBadge)
                Positioned(
                  top: 10,
                  right: 11,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.activeCoral,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Starburst / serrated Rhema Gold sticker badge (inspired by Screen 3 of the Pinterest reference).
class StarburstStickerBadge extends StatelessWidget {
  final String topText;
  final String bottomText;
  final double size;

  const StarburstStickerBadge({
    super.key,
    required this.topText,
    required this.bottomText,
    this.size = 66,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StarburstPainter(color: AppColors.rhemaGold),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                topText,
                style: const TextStyle(
                  color: AppColors.rhemaNavy,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                bottomText,
                style: const TextStyle(
                  color: AppColors.rhemaNavy,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StarburstPainter extends CustomPainter {
  final Color color;

  _StarburstPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    const int points = 24;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double outerRadius = size.width / 2;
    final double innerRadius = outerRadius * 0.88;

    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (i * math.pi) / points;
      final x = centerX + radius * math.cos(angle);
      final y = centerY + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom vector emblem representing the Rhema Bible Training Center Nigeria seal.
class RhemaCrestEmblem extends StatelessWidget {
  final double size;

  const RhemaCrestEmblem({super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFF284878), Color(0xFF102038)],
        ),
        border: Border.all(color: AppColors.rhemaGold, width: size * 0.045),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * 0.76,
            height: size * 0.76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.rhemaGold.withValues(alpha: 0.45),
                width: 1,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.menu_book_rounded,
                color: AppColors.rhemaGold,
                size: size * 0.36,
              ),
              const SizedBox(height: 1),
              Text(
                'RHEMA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
