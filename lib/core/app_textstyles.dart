import 'package:flutter/material.dart';
import 'package:musuem_guide_app_ui/constants/string_const.dart';
import 'package:musuem_guide_app_ui/core/app_colors.dart';

class AppTextStyles {
  static const welcomeTitle = TextStyle(
    fontFamily: StringConst.appFontFamily,
    fontWeight: FontWeight.w800,
    fontSize: 28,
    height: 1.3,
    letterSpacing: -0.28,
    color: AppColors.textPrimary,
  );

  static const sectionTitle = TextStyle(
    fontFamily: StringConst.appFontFamily,
    fontWeight: FontWeight.w800,
    fontSize: 20,
    height: 1.278,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );

  static const cardTitle = TextStyle(
    fontFamily: StringConst.appFontFamily,
    fontWeight: FontWeight.w800,
    fontSize: 16,
    height: 1.278,
    letterSpacing: -0.16,
    color: AppColors.textPrimary,
  );

  static const detailTitle = TextStyle(
    fontFamily: StringConst.appFontFamily,
    fontWeight: FontWeight.w800,
    fontSize: 24,
    height: 1.278,
    letterSpacing: -0.24,
    color: AppColors.textPrimary,
  );

  static const scanningTitle = TextStyle(
    fontFamily: StringConst.appFontFamily,
    fontWeight: FontWeight.w800,
    fontSize: 24,
    height: 1.278,
    letterSpacing: -0.24,
    color: AppColors.white,
  );

  static const detailButton = TextStyle(
    fontFamily: StringConst.appFontFamily,
    fontWeight: FontWeight.w800,
    fontSize: 14,
    height: 18 / 14,
    color: AppColors.textPrimary,
  );

  static const searchHint = TextStyle(
    fontFamily: StringConst.appFontFamily,
    fontWeight: FontWeight.w300,
    fontSize: 14,
    height: 1.138,
    letterSpacing: -0.28,
    color: AppColors.textPrimary,
  );

  static const locationLabel = TextStyle(
    fontFamily: StringConst.appFontFamily,
    fontWeight: FontWeight.w300,
    fontSize: 14,
    height: 1.138,
    letterSpacing: -0.28,
    color: AppColors.textPrimary,
  );

  static const metaLabel = TextStyle(
    fontFamily: StringConst.appFontFamilyLato,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.138,
    letterSpacing: -0.28,
    color: AppColors.textSecondary,
  );

  static const cardMeta = TextStyle(
    fontFamily: StringConst.appFontFamilyLato,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.138,
    letterSpacing: -0.28,
    color: AppColors.textMeta,
  );

  static const scanningYear = TextStyle(
    fontFamily: StringConst.appFontFamilyLato,
    fontWeight: FontWeight.w800,
    fontSize: 18,
    height: 1.138,
    letterSpacing: -0.36,
    color: AppColors.textMeta,
  );

  static const detailYear = TextStyle(
    fontFamily: StringConst.appFontFamilyLato,
    fontWeight: FontWeight.w800,
    fontSize: 14,
    height: 1.138,
    letterSpacing: -0.28,
    color: AppColors.textMeta,
  );

  static const bodyDescription = TextStyle(
    fontFamily: StringConst.appFontFamilyLato,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.5,
    letterSpacing: 0.56,
    color: AppColors.textMeta,
  );
}
