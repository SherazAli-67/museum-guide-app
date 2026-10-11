import 'package:flutter/material.dart';
import 'package:musuem_guide_app_ui/constants/number_constant.dart';
import 'package:musuem_guide_app_ui/core/app_colors.dart';
import 'package:musuem_guide_app_ui/core/app_textstyles.dart';
import 'package:musuem_guide_app_ui/core/asset_res.dart';
import 'package:musuem_guide_app_ui/core/models/exhibit_model.dart';
import 'package:musuem_guide_app_ui/presentation/widgets/app_icon_button.dart';

class ExhibitListTile extends StatefulWidget {
  final ExhibitModel exhibit;
  final VoidCallback? onTap;

  const ExhibitListTile({
    super.key,
    required this.exhibit,
    this.onTap,
  });

  @override
  State<ExhibitListTile> createState() => _ExhibitListTileState();
}

class _ExhibitListTileState extends State<ExhibitListTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
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
                child: Image.asset(widget.exhibit.thumbnailPath, height: NumberConstant.listThumbnailSize,)
              ),
              Expanded(
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: .start,
                  mainAxisAlignment: .center,
                  children: [
                    Text(widget.exhibit.title, style: AppTextStyles.cardTitle,),
                    Text(widget.exhibit.yearLabel, style: AppTextStyles.metaLabel,)
                  ],
                ),
              ),
              AppIconButton.surface(
                iconPath: AssetRes.icArrowNext,
                onTap: widget.onTap,
                colorFilter: .mode(AppColors.textPrimary, .srcIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
