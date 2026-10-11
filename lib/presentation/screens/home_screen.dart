import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:musuem_guide_app_ui/constants/number_constant.dart';
import 'package:musuem_guide_app_ui/constants/string_const.dart';
import 'package:musuem_guide_app_ui/core/app_colors.dart';
import 'package:musuem_guide_app_ui/core/app_textstyles.dart';
import 'package:musuem_guide_app_ui/core/asset_res.dart';
import 'package:musuem_guide_app_ui/core/models/exhibit_model.dart';
import 'package:musuem_guide_app_ui/presentation/widgets/exhibit_list_tile.dart';
import 'package:musuem_guide_app_ui/presentation/widgets/glass_card.dart';
import 'package:musuem_guide_app_ui/provider/home_provider.dart';
import 'package:musuem_guide_app_ui/routing/router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Consumer<HomeProvider>(
                builder: (context, provider, _) => CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: .fromLTRB(NumberConstant.horizontalPadding, 16, NumberConstant.horizontalPadding, 100),
                      sliver: SliverMainAxisGroup(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Column(
                              spacing: NumberConstant.contentGap,
                              crossAxisAlignment: .start,
                              children: [
                                _buildHeader(),
                                Text(StringConst.welcomeTitle, style: AppTextStyles.welcomeTitle.copyWith(fontWeight: .w800),),
                                _buildSearchField(),
                                Text(StringConst.nearBy, style: AppTextStyles.sectionTitle,),
                                SizedBox(
                                  height: NumberConstant.nearbyCardHeight,
                                  child: ListView.separated(
                                    scrollDirection: .horizontal,
                                    itemCount: provider.nearbyExhibits.length,
                                    separatorBuilder: (_, _) => const SizedBox(width: NumberConstant.nearbyCardGap),
                                    itemBuilder: (context, index) => _buildNearbyCard(context, provider.nearbyExhibits[index]),
                                  ),
                                ),
                                Text(StringConst.firstFloor, style: AppTextStyles.sectionTitle,),
                              ],
                            ),
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: NumberConstant.contentGap),),
                          SliverList.separated(
                            itemCount: provider.firstFloorExhibits.length,
                            separatorBuilder: (_, _) => const SizedBox(height: NumberConstant.listCardGap),
                            itemBuilder: (context, index) {
                              final exhibit = provider.firstFloorExhibits[index];
                              return ExhibitListTile(
                                exhibit: exhibit,
                                onTap: () => context.push(NamedRoutes.detailPath(exhibit.id)),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: NumberConstant.horizontalPadding,
              bottom: MediaQuery.paddingOf(context).bottom + 24,
              child: _buildScannerFab(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      spacing: NumberConstant.contentGap,
      children: [
        SvgPicture.asset(AssetRes.icDrawer, colorFilter: .mode(AppColors.textPrimary, .srcIn),),
        Expanded(
          child: Container(
            padding: .symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: .circular(NumberConstant.cardRadius),
            ),
            child: Row(
              spacing: 5,
              children: [
                SvgPicture.asset(AssetRes.icLocationPin, colorFilter: .mode(AppColors.textPrimary, .srcIn),),
                Expanded(child: Text(StringConst.locationDefault, style: AppTextStyles.locationLabel, maxLines: 1, overflow: .ellipsis,),),
                SvgPicture.asset(AssetRes.icDropdown, colorFilter: .mode(AppColors.textPrimary, .srcIn),),
              ],
            ),
          ),
        ),
        ClipRRect(
          borderRadius: .circular(NumberConstant.avatarRadius),
          child: Image.asset(
            AssetRes.profileAvatarImg,
            width: NumberConstant.avatarSize,
            height: NumberConstant.avatarSize,
            fit: .cover,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) => Container(
        height: NumberConstant.searchHeight,
        padding: .symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: .circular(NumberConstant.searchRadius),
        ),
        child: Row(
          spacing: NumberConstant.contentGap,
          children: [
            Expanded(
              child: TextField(
                onChanged: provider.updateQuery,
                style: AppTextStyles.searchHint,
                cursorColor: AppColors.textPrimary,
                decoration: InputDecoration(
                  isDense: true,
                  border: .none,
                  hintText: StringConst.searchHint,
                  hintStyle: AppTextStyles.searchHint,
                  contentPadding: .zero,
                ),
              ),
            ),
            SvgPicture.asset(AssetRes.icSearch, colorFilter: .mode(AppColors.textPrimary, .srcIn),),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyCard(BuildContext context, ExhibitModel exhibit) {
    final metaIcon = exhibit.stepsAway != null ? AssetRes.icFootsteps : AssetRes.icTowardRight;
    final metaLabel = exhibit.stepsAway != null
        ? '${exhibit.stepsAway}${StringConst.stepsAwaySuffix}'
        : (exhibit.directionLabel ?? '');
    return SizedBox(
      width: NumberConstant.nearbyCardWidth,
      height: NumberConstant.nearbyCardHeight,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: .circular(20),
              child: Image.asset(exhibit.imagePath, fit: .cover,),
            ),
          ),
          Positioned(
            left: 8,
            right: 8,
            bottom: 8,
            child: GlassCard(
              padding: .all(12),
              child: Column(
                spacing: 8,
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(child: Text(exhibit.title, style: AppTextStyles.cardTitle, maxLines: 1, overflow: .ellipsis,),),
                      Text(exhibit.yearLabel, style: AppTextStyles.cardMeta,),
                    ],
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: Row(
                          spacing: 8,
                          children: [
                            SvgPicture.asset(metaIcon, colorFilter: .mode(AppColors.textPrimary, .srcIn),),
                            Flexible(child: Text(metaLabel, style: AppTextStyles.cardMeta, maxLines: 1, overflow: .ellipsis,),),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push(NamedRoutes.detailPath(exhibit.id)),
                        child: Container(
                          padding: .symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: .circular(NumberConstant.cardRadius),
                          ),
                          child: Text(StringConst.detail, style: AppTextStyles.detailButton,),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerFab(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(NamedRoutes.scanning.routeName),
      child: Container(
        padding: .all(21.5),
        decoration: BoxDecoration(
          color: AppColors.scannerDark,
          shape: .circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.scannerShadow,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SvgPicture.asset(AssetRes.icScanner,),
      ),
    );
  }
}
