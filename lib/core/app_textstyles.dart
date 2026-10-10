import 'package:flutter/material.dart';
import 'package:musuem_guide_app_ui/core/app_colors.dart';

class AppTextStyles {
  static const _gilroy = 'Gilroy';
  static const _lato = 'Lato';

  static const welcomeTitle = TextStyle(
    fontFamily: _gilroy,
    fontWeight: FontWeight.w800,
    fontSize: 28,
    height: 1.3,
    letterSpacing: -0.28,
    color: AppColors.textPrimary,
  );

  static const sectionTitle = TextStyle(
    fontFamily: _gilroy,
    fontWeight: FontWeight.w800,
    fontSize: 20,
    height: 1.278,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );

  static const cardTitle = TextStyle(
    fontFamily: _gilroy,
    fontWeight: FontWeight.w800,
    fontSize: 16,
    height: 1.278,
    letterSpacing: -0.16,
    color: AppColors.textPrimary,
  );

  static const detailTitle = TextStyle(
    fontFamily: _gilroy,
    fontWeight: FontWeight.w800,
    fontSize: 24,
    height: 1.278,
    letterSpacing: -0.24,
    color: AppColors.textPrimary,
  );

  static const scanningTitle = TextStyle(
    fontFamily: _gilroy,
    fontWeight: FontWeight.w800,
    fontSize: 24,
    height: 1.278,
    letterSpacing: -0.24,
    color: AppColors.white,
  );

  static const detailButton = TextStyle(
    fontFamily: _gilroy,
    fontWeight: FontWeight.w800,
    fontSize: 14,
    height: 18 / 14,
    color: AppColors.textPrimary,
  );

  static const searchHint = TextStyle(
    fontFamily: _gilroy,
    fontWeight: FontWeight.w300,
    fontSize: 14,
    height: 1.138,
    letterSpacing: -0.28,
    color: AppColors.textPrimary,
  );

  static const locationLabel = TextStyle(
    fontFamily: _gilroy,
    fontWeight: FontWeight.w300,
    fontSize: 14,
    height: 1.138,
    letterSpacing: -0.28,
    color: AppColors.textPrimary,
  );

  static const metaLabel = TextStyle(
    fontFamily: _lato,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.138,
    letterSpacing: -0.28,
    color: AppColors.textSecondary,
  );

  static const cardMeta = TextStyle(
    fontFamily: _lato,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.138,
    letterSpacing: -0.28,
    color: AppColors.textMeta,
  );

  static const scanningYear = TextStyle(
    fontFamily: _lato,
    fontWeight: FontWeight.w800,
    fontSize: 18,
    height: 1.138,
    letterSpacing: -0.36,
    color: AppColors.textMeta,
  );

  static const detailYear = TextStyle(
    fontFamily: _lato,
    fontWeight: FontWeight.w800,
    fontSize: 14,
    height: 1.138,
    letterSpacing: -0.28,
    color: AppColors.textMeta,
  );

  static const bodyDescription = TextStyle(
    fontFamily: _lato,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.5,
    letterSpacing: 0.56,
    color: AppColors.textMeta,
  );
}
