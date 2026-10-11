import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:musuem_guide_app_ui/constants/number_constant.dart';
import 'package:musuem_guide_app_ui/constants/string_const.dart';
import 'package:musuem_guide_app_ui/core/app_colors.dart';
import 'package:musuem_guide_app_ui/core/app_data.dart';
import 'package:musuem_guide_app_ui/core/app_textstyles.dart';
import 'package:musuem_guide_app_ui/core/asset_res.dart';
import 'package:musuem_guide_app_ui/core/models/exhibit_model.dart';
import 'package:musuem_guide_app_ui/presentation/widgets/app_icon_button.dart';
import 'package:musuem_guide_app_ui/presentation/widgets/glass_card.dart';

class DetailScreen extends StatelessWidget {
  static const _designWidth = 428.0;
  static const _designHeight = 926.0;

  final String exhibitId;

  const DetailScreen({super.key, required this.exhibitId});

  @override
  Widget build(BuildContext context) {
    final exhibit = AppData.exhibitById(exhibitId) ?? AppData.dioskouroi;
    return Scaffold(
      backgroundColor: const Color(0xFFBFBFBF),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scaleX = constraints.maxWidth / _designWidth;
          final scaleY = constraints.maxHeight / _designHeight;
          return Stack(
            fit: .expand,
            children: [
              Positioned(
                child: Image.asset(AssetRes.detailPageImg, fit: .cover,),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 207 * scaleY,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: .topCenter,
                        end: .bottomCenter,
                        colors: [
                          AppColors.overlayBlack.withValues(alpha: 0.6),
                          AppColors.overlayBlack.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 494 * scaleY,
                height: 432 * scaleY,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: .topCenter,
                        end: .bottomCenter,
                        colors: [
                          AppColors.background.withValues(alpha: 0),
                          AppColors.background,
                        ],
                        stops: const [0.63, 1],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 79 * scaleX,
                top: 365 * scaleY,
                child: Transform.scale(
                  scale: scaleX,
                  alignment: .topLeft,
                  child: SvgPicture.asset(AssetRes.icRotate,),
                ),
              ),
              Positioned(
                left: 203 * scaleX,
                top: 690 * scaleY,
                child: Transform.scale(
                  scale: scaleX,
                  alignment: .topLeft,
                  child: SvgPicture.asset(AssetRes.icSwipeUp,),
                ),
              ),
              Positioned(
                left: NumberConstant.horizontalPadding * scaleX,
                bottom: 0,
                width: (_designWidth - NumberConstant.horizontalPadding * 2) * scaleX,
                child: _buildInfoCard(exhibit),
              ),
              Positioned(
                left: 338 * scaleX,
                top: 700 * scaleY,
                child: AppIconButton.audio(iconPath: AssetRes.icHeadphones,),
              ),
              Positioned(
                left: NumberConstant.horizontalPadding * scaleX,
                top: 40 * scaleY,
                child: AppIconButton.back(
                  iconPath: AssetRes.icArrowBackLight,
                  onTap: () => context.pop(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(ExhibitModel exhibit) {
    return GlassCard(
      height: NumberConstant.detailSheetHeight,
      padding: .fromLTRB(17, 17, 17, 12),
      child: Column(
        spacing: 8,
        crossAxisAlignment: .start,
        children: [
          Text(exhibit.title, style: AppTextStyles.detailTitle,),
          Text('${StringConst.yearPrefix}${exhibit.yearLabel}', style: AppTextStyles.detailYear,),
          Expanded(
            child: ShaderMask(
              blendMode: .dstIn,
              shaderCallback: (bounds) => LinearGradient(
                begin: .topCenter,
                end: .bottomCenter,
                colors: [
                  AppColors.white,
                  AppColors.white,
                  AppColors.white.withValues(alpha: 0),
                ],
                stops: const [0, 0.72, 1],
              ).createShader(bounds),
              child: Text(
                exhibit.description,
                style: AppTextStyles.bodyDescription,
                overflow: .clip,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
