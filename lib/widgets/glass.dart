import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class Glass extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final double sigma;
  final Color? color;
  const Glass({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.sigma = 20,
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Container(
          decoration: BoxDecoration(
            color: color ?? AppColors.glassFill,
            border: Border.all(color: AppColors.glassBorder, width: 1),
            borderRadius: borderRadius,
          ),
          child: child,
        ),
      ),
    );
  }
}
