import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// iOS-style glass: BackdropFilter blur + полупрозрачный fill + тонкая граница.
/// Параметры подобраны под исходный HTML (.surface2 ~55%, blur 20px, border 1px rgba(255,255,255,0.06))
class Glass extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final double sigma;
  final Color? fill;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;

  const Glass({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.sigma = 20,
    this.fill,
    this.borderColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: fill ?? AppColors.glassFill,
            borderRadius: borderRadius,
            border: Border.all(
              color: borderColor ?? AppColors.glassBorder,
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
