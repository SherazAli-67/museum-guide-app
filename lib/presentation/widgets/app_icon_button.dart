import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:musuem_guide_app_ui/constants/number_constant.dart';
import 'package:musuem_guide_app_ui/core/app_colors.dart';

class AppIconButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double blur;
  final ColorFilter? colorFilter;
  final BoxShape shape;

  const AppIconButton({
    super.key,
    required this.iconPath,
    this.onTap,
    this.backgroundColor = AppColors.backButtonFill,
    this.padding = const .all(8),
    this.borderRadius = NumberConstant.backButtonRadius,
    this.blur = NumberConstant.backButtonBlur,
    this.colorFilter,
    this.shape = .rectangle,
  });

  const AppIconButton.back({
    super.key,
    required this.iconPath,
    this.onTap,
    this.backgroundColor = AppColors.backButtonFill,
    this.padding = const .all(8),
    this.borderRadius = NumberConstant.backButtonRadius,
    this.blur = NumberConstant.backButtonBlur,
    this.colorFilter,
    this.shape = .rectangle,
  });

  const AppIconButton.surface({
    super.key,
    required this.iconPath,
    this.onTap,
    this.backgroundColor = AppColors.surface,
    this.padding = const .all(10),
    this.borderRadius = 8,
    this.blur = NumberConstant.backButtonBlur,
    this.colorFilter,
    this.shape = .rectangle,
  });

  const AppIconButton.audio({
    super.key,
    required this.iconPath,
    this.onTap,
    this.backgroundColor = AppColors.white,
    this.padding = const .all(9),
    this.borderRadius = 24,
    this.blur = NumberConstant.backButtonBlur,
    this.colorFilter,
    this.shape = .circle,
  });

  @override
  Widget build(BuildContext context) {
    final isCircle = shape == .circle;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: isCircle ? .circular(999) : .circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: shape,
              borderRadius: isCircle ? null : .circular(borderRadius),
            ),
            child: SvgPicture.asset(iconPath, colorFilter: colorFilter,),
          ),
        ),
      ),
    );
  }
}
