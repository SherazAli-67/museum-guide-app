import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:musuem_guide_app_ui/constants/number_constant.dart';
import 'package:musuem_guide_app_ui/constants/string_const.dart';
import 'package:musuem_guide_app_ui/core/app_colors.dart';
import 'package:musuem_guide_app_ui/core/app_textstyles.dart';
import 'package:musuem_guide_app_ui/core/asset_res.dart';
import 'package:musuem_guide_app_ui/presentation/widgets/app_icon_button.dart';
import 'package:musuem_guide_app_ui/presentation/widgets/glass_card.dart';
import 'package:musuem_guide_app_ui/provider/scanning_provider.dart';
import 'package:musuem_guide_app_ui/routing/router.dart';

class ScanningScreen extends StatelessWidget {
  const ScanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScanningProvider(),
      child: Scaffold(
        backgroundColor: AppColors.overlayBlack,
        body: Consumer<ScanningProvider>(
          builder: (context, provider, _) => LayoutBuilder(
            builder: (context, constraints) {
              final scaleX = constraints.maxWidth / ScanningProvider.designWidth;
              final scaleY = constraints.maxHeight / ScanningProvider.designHeight;
              return Stack(
                fit: .expand,
                children: [
                  Image.asset(
                    AssetRes.scanningHallImg,
                    fit: .cover,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 174 * scaleY,
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
                    bottom: 0,
                    height: 408 * scaleY,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: .topCenter,
                            end: .bottomCenter,
                            colors: [
                              AppColors.overlayBlack.withValues(alpha: 0),
                              AppColors.overlayBlack.withValues(alpha: 0.4),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  for (var i = 0; i < ScanningProvider.hotspots.length; i++)
                    if (i != provider.selectedIndex)
                      Positioned(
                        left: ScanningProvider.hotspots[i].left * scaleX,
                        top: ScanningProvider.hotspots[i].top * scaleY,
                        child: GestureDetector(
                          onTap: () => provider.selectHotspot(i),
                          child: _buildInactiveHotspot(scaleX),
                        ),
                      ),
                  _buildSelectedCardGroup(context, provider, scaleX, scaleY),
                  Positioned(
                    top: 40 * scaleY,
                    left: NumberConstant.horizontalPadding * scaleX,
                    right: NumberConstant.horizontalPadding * scaleX,
                    child: SizedBox(
                      height: 40,
                      child: Stack(
                        alignment: .center,
                        children: [
                          Text(StringConst.scanning, style: AppTextStyles.scanningTitle,),
                          Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              AppIconButton.back(
                                iconPath: AssetRes.icArrowBackLight,
                                onTap: () => context.pop(),
                              ),
                              const _ScanningSpinner(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInactiveHotspot(double scale) {
    return SizedBox(
      width: 43 * scale,
      height: 43 * scale,
      child: SvgPicture.asset(AssetRes.hotspotDot)
    );
  }

  Widget _buildSelectedCardGroup(
    BuildContext context,
    ScanningProvider provider,
    double scaleX,
    double scaleY,
  ) {
    final hotspot = provider.selectedHotspot;
    final exhibit = provider.selectedExhibit;
    final isDefaultActive = provider.selectedIndex == 3;
    final cardLeft = isDefaultActive ? 96.0 : (hotspot.left - 180).clamp(24.0, 96.0);
    final cardTop = isDefaultActive ? 656.68 : (hotspot.top + 83.68).clamp(0.0, ScanningProvider.designHeight - 160);
    final connectorLeft = isDefaultActive ? 327.06 : hotspot.left;
    final connectorTop = isDefaultActive ? 573.0 : hotspot.top;

    return Stack(
      children: [
        Positioned(
          left: connectorLeft * scaleX,
          top: connectorTop * scaleY,
          child: GestureDetector(
            onTap: () {},
            child: Transform.scale(
              scale: scaleX,
              alignment: .topLeft,
              child: Transform.flip(
                flipY: true,
                child: SvgPicture.asset(AssetRes.icHotspotConnector,),
              ),
            ),
          ),
        ),
        Positioned(
          left: cardLeft * scaleX,
          top: cardTop * scaleY,
          width: NumberConstant.scanningCardWidth * scaleX,
          child: GlassCard(
            height: NumberConstant.scanningCardHeight,
            padding: .fromLTRB(12, 12, 16, 12),
            child: Row(
              spacing: 12,
              children: [
                ClipRRect(
                  borderRadius: .circular(8),
                  child: Image.asset(
                    AssetRes.scanningHallImg,
                    width: NumberConstant.scanningThumbWidth,
                    height: NumberConstant.scanningThumbHeight,
                    fit: .cover,
                  ),
                ),
                Expanded(
                  child: Column(
                    spacing: 6,
                    crossAxisAlignment: .start,
                    mainAxisAlignment: .start,
                    children: [
                      Text(exhibit.title, style: AppTextStyles.detailTitle, maxLines: 1, overflow: .ellipsis,),
                      Text(exhibit.displayShortYear, style: AppTextStyles.scanningYear,),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => context.push(NamedRoutes.detailPath(exhibit.id)),
                        child: Container(
                          width: 84,
                          alignment: .center,
                          padding: .symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: .circular(NumberConstant.cardRadius),
                          ),
                          child: Text(StringConst.detail, style: AppTextStyles.detailButton,),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ScanningSpinner extends StatefulWidget {
  const _ScanningSpinner();

  @override
  State<_ScanningSpinner> createState() => _ScanningSpinnerState();
}

class _ScanningSpinnerState extends State<_ScanningSpinner> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: SvgPicture.asset(AssetRes.icLoading,),
    );
  }
}
