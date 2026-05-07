import 'package:flutter/material.dart';

class ZynLogo extends StatelessWidget {
  const ZynLogo({
    super.key,
    this.size = 72,
    this.radius = 20,
    this.showPlate = false,
    this.plateColor,
    this.padding = const EdgeInsets.all(0),
  });

  final double size;
  final double radius;
  final bool showPlate;
  final Color? plateColor;
  final EdgeInsets padding;

  static const assetPath = 'assets/branding/logo_zyn.png';

  @override
  Widget build(BuildContext context) {
    final logo = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );

    if (!showPlate) {
      return Padding(padding: padding, child: logo);
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: plateColor ?? Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(radius + 8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: logo,
    );
  }
}
