import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:musuem_guide_app_ui/constants/number_constant.dart';
import 'package:musuem_guide_app_ui/core/app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double blur;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = NumberConstant.cardRadius,
    this.blur = NumberConstant.glassCardBlur,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = ClipRRect(
      borderRadius: .circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: .circular(borderRadius),
            gradient: LinearGradient(
              begin: const Alignment(-0.8, -0.6),
              end: const Alignment(0.8, 0.8),
              colors: [
                AppColors.glassWhite,
                AppColors.glassWhiteOpaque,
              ],
              stops: const [0.24, 0.8],
            ),
          ),
          child: child,
        ),
      ),
    );
    if (onTap == null) return content;
    return GestureDetector(onTap: onTap, child: content,);
  }
}
