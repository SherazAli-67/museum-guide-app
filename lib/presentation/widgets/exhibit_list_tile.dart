import 'package:flutter/material.dart';
import 'package:musuem_guide_app_ui/constants/number_constant.dart';
import 'package:musuem_guide_app_ui/core/app_colors.dart';
import 'package:musuem_guide_app_ui/core/app_textstyles.dart';
import 'package:musuem_guide_app_ui/core/asset_res.dart';
import 'package:musuem_guide_app_ui/core/models/exhibit_model.dart';
import 'package:musuem_guide_app_ui/presentation/widgets/app_icon_button.dart';

class ExhibitListTile extends StatelessWidget {
  final ExhibitModel exhibit;
  final VoidCallback? onTap;

  const ExhibitListTile({
    super.key,
    required this.exhibit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: NumberConstant.listCardHeight,
        padding: .symmetric(horizontal: 9, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: .circular(NumberConstant.listCardRadius),
          gradient: LinearGradient(
            begin: const Alignment(-0.7, -0.5),
            end: const Alignment(0.9, 0.8),
            colors: [
              AppColors.white,
              AppColors.white.withValues(alpha: 0),
            ],
            stops: const [0.41, 0.88],
          ),
        ),
        child: Row(
          spacing: 17,
          children: [
            ClipRRect(
              borderRadius: .circular(NumberConstant.cardRadius),
              child: Image.asset(
                exhibit.thumbnailPath,
                width: NumberConstant.listThumbnailSize,
                height: NumberConstant.listThumbnailSize,
                fit: .cover,
              ),
            ),
            Expanded(
              child: Column(
                spacing: 5,
                crossAxisAlignment: .start,
                mainAxisAlignment: .center,
                children: [
                  Text(exhibit.title, style: AppTextStyles.cardTitle, maxLines: 1, overflow: .ellipsis,),
                  Text(exhibit.yearLabel, style: AppTextStyles.metaLabel,),
                ],
              ),
            ),
            AppIconButton.surface(
              iconPath: AssetRes.icArrowNext,
              onTap: onTap,
              colorFilter: .mode(AppColors.textPrimary, .srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
